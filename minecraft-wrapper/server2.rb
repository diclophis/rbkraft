#!/usr/bin/env ruby

$: << File.dirname(__FILE__)
$: << File.dirname(__FILE__) + '/lib'

require 'dynasty'
require 'wrapper'
require 'syslog'
require 'logger'
require 'fluent-logger'
require 'objspace'

$stdout.sync = true

SELECT_WRITABLE = false
SELECT_SLEEP = 0.001 #999.9

# Start a hot-reloadable server on desired socket
Dynasty.server(ENV["DYNASTY_SOCK"] || raise("missing env"), ENV["DYNASTY_FORCE"]) do |dynasty|
  if fluentd_url = ENV["FLUENTD_URL"]
    uri = URI.parse fluentd_url
    #params = CGI.parse uri.query
    fluent_logger = Fluent::Logger::FluentLogger.open(
      'mavencraft',
      :host => uri.host,
      :port => uri.port,
      :use_nonblock => true
    )
  else
    fluent_logger = Fluent::Logger::ConsoleLogger.open($stdout)
  end

  class RawFormatter < Logger::Formatter
    def call(severity, time, progname, msg)
      return severity, time, progname, msg
    end
  end

  class AsyncableLogger < SimpleDelegator
    def write(arg)
      severity, time, progname, msg = *arg
      # ["DEBUG", 2020-03-15 13:45:26 -0400, nil, {"extra"=>"detail"}]
      post(severity, msg)
    end
  end

  inner_logger = AsyncableLogger.new(fluent_logger)

  #logger = Logger.new(inner_logger)

  logger = Logger.new(inner_logger)
  logger.formatter = RawFormatter.new
  logger.level = Logger::INFO
  #logger.debug({"extra" => "detail"})
  #logger.info({"extra" => "detail"})
  #logger.warn({"extra" => "detail"})
  #logger.fatal({"extra" => "detail"})

  # In your server, consume any ancestored descriptors, order is important
  # this case, the first 3 sockets are the stdin,stdout,stderr of the wrapped
  # command using the Wrapper class
  wrapper = Wrapper.new(logger, dynasty.descriptors, ARGV)

  # Install your main server runloop
  while wrapper.running
    # Along with your own descriptors, select() over the dynasty socket
    selectable_sockets = dynasty.selectable_descriptors + wrapper.selectable_descriptors

    if SELECT_WRITABLE
      sleep SELECT_SLEEP 
      writable_sockets = wrapper.writable_descriptors
    else
      writable_sockets = []
    end

    open_selectable_sockets = selectable_sockets.reject { |io| io.closed? }
    open_writable_sockets = writable_sockets.reject { |io| io.closed? }

    next unless (open_selectable_sockets.length > 0 || open_writable_sockets.length > 0)

    readable, writable, _errored = IO.select(open_selectable_sockets, open_writable_sockets, selectable_sockets, SELECT_SLEEP)

    # NOTE: When the dynasty socket is passed on, we need to exit immediatly
    # because we no longer own the sockets we have reference to
    break unless dynasty.handle_descriptors_requiring_reading(readable, wrapper.descriptors)

    if readable
      dynasty.selectable_descriptors.each { |dio| readable.delete(dio) }
    end

    if SELECT_WRITABLE
      if writable && writable.length > 0
        # If the wrapped command is still running
        if wrapper.running
          wrapper.handle_descriptors_requiring_writing(writable)
        end
      end
    else
      wrapper.handle_descriptors_requiring_writing(wrapper.writable_descriptors)
    end

    # When something is ready to read
    if readable && readable.length > 0
      # If the wrapped command is still running
      if wrapper.running
        ff = wrapper.handle_descriptors_requiring_reading(readable)
      end
    end
  end
end
