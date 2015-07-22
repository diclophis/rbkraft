#!/usr/bin/env ruby

$: << File.dirname(__FILE__)
$: << File.dirname(__FILE__) + '/lib'

require 'dynasty'
require 'wrapper'
require 'syslog'

SELECT_WRITABLE = false
SELECT_SLEEP = 0.1

# Start a hot-reloadable server on desired socket
Dynasty.server(ENV["DYNASTY_SOCK"] || "/tmp/dynasty.sock", ENV["DYNASTY_FORCE"]) do |dynasty|
  # log to the system log
  #logger = Syslog.open("mavencraft", nil, Syslog::LOG_DAEMON) #Syslog::LOG_PERROR, Syslog::LOG_DAEMON)
  logger = Syslog.open("mavencraft", Syslog::LOG_PERROR, Syslog::LOG_DAEMON)

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
    
    #readable.reject! { |io|
    #  begin
    #    io.eof?
    #  rescue Errno::ECONNRESET, Errno::ENOTCONN => e
    #    # Transport endpoint is not connected
    #    puts e.inspect
    #  end
    #}

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
