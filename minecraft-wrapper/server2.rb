#!/usr/bin/env ruby

$: << File.dirname(__FILE__)
$: << File.dirname(__FILE__) + '/lib'

require 'dynasty'
require 'wrapper'

# Start a hot-reloadable server on desired socket
Dynasty.server(ENV["DYNASTY_SOCK"] || "/tmp/dynasty.sock", ENV["DYNASTY_FORCE"]) do |dynasty|

  # In your server, consume any ancestored descriptors, order is important
  # this case, the first 3 sockets are the stdin,stdout,stderr of the wrapped
  # command using the Wrapper class
  wrapper = Wrapper.new(dynasty.descriptors, ARGV)

  # Install your main server runloop
  while wrapper.running

    # Along with your own descriptors, select() over the dynasty socket
    selectable_sockets = dynasty.selectable_descriptors + wrapper.selectable_descriptors
    writable_sockets = wrapper.writable_descriptors

    open_selectable_sockets = selectable_sockets.reject { |io| io.closed? }
    open_writable_sockets = writable_sockets.reject { |io| io.closed? }

    next unless (open_selectable_sockets.length > 0 || open_writable_sockets.length > 0)

    readable, writable, _errored = IO.select(open_selectable_sockets, open_writable_sockets, selectable_sockets, 1.0)

    if writable && writable.length > 0
      # If the wrapped command is still running
      if wrapper.running
        #$stderr.write("w#{writable.length}\n")
        wrapper.handle_descriptors_requiring_writing(writable)
      end
    end

    # When something is ready to read
    if readable && readable.length > 0
      # NOTE: When the dynasty socket is passed on, we need to exit immediatly
      # because we no longer own the sockets we have reference to
      break unless dynasty.handle_descriptors_requiring_reading(readable, wrapper.descriptors)

      # If the wrapped command is still running
      if wrapper.running
        #$stderr.write("r#{readable.length}\n")
        wrapper.handle_descriptors_requiring_reading(readable)
      end
    end

    sleep 0.005 # to prevent cpu burn
  end
end
