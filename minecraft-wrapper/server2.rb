#!/usr/bin/env ruby

#TODO: pull dynasty into seperate gem repo

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

if fluentd_url = ENV["FLUENTD_URL"]
  uri = URI.parse fluentd_url
  fluent_logger = Fluent::Logger::FluentLogger.open(
    'rbkraft',
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
    post(severity, msg)
  end
end

inner_logger = AsyncableLogger.new(fluent_logger)
logger = Logger.new(inner_logger)
logger.formatter = RawFormatter.new
logger.level = Logger.const_get(ENV["RUBY_LOGGER_LEVEL"] || "DEBUG")

# Start a hot-reloadable server on desired socket
Dynasty.server(ENV["DYNASTY_SOCK"] || raise("missing env"), ENV["DYNASTY_FORCE"]) do |dynasty|
  # In your server, consume any ancestored descriptors, order is important
  # this case, the first 3 sockets are the stdin,stdout,stderr of the wrapped
  # command using the Wrapper class
  wrapper = Wrapper.new(logger, dynasty.descriptors, ARGV)

  # Install your main server runloop
  while wrapper.running
    # Along with your own descriptors, select() over the dynasty socket
    selectable_sockets = dynasty.selectable_descriptors + wrapper.selectable_descriptors
    open_selectable_sockets = selectable_sockets.reject { |io| io.closed? }
    next unless (open_selectable_sockets.length > 0)
    readable, writable, _errored = IO.select(open_selectable_sockets, [], selectable_sockets, SELECT_SLEEP)

    # NOTE: When the dynasty socket is passed on, we need to exit immediatly
    # because we no longer own the sockets we have reference to
    break unless dynasty.handle_descriptors_requiring_reading(readable, wrapper.descriptors)

    #WRITE to the mc server stdin
    wrapper.handle_descriptors_requiring_writing(wrapper.writable_descriptors)

    # When something is ready to read
    if readable && readable.length > 0
      # clear out the nc.sock used for dynasty connection passing
      dynasty.selectable_descriptors.each { |dio| readable.delete(dio) }

      # If the wrapped command is still running
      if wrapper.running
        wrapper.handle_descriptors_requiring_reading(readable)
      end
    end
  end
end
