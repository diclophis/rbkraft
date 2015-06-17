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
    puts selectable_sockets.inspect
    readable, _writable, _errored = IO.select(selectable_sockets, nil, selectable_sockets, 2.0)
    #puts readable.inspect

    # When something is ready to read
    if readable
      #$stdout.write("+")
      #$stdout.write(readable.inspect)
      #$stdin.gets

      # NOTE: When the dynasty socket is passed on, we need to exit immediatly
      # because we no longer own the sockets we have reference to
      break unless dynasty.handle_descriptors_requiring_reading(readable, wrapper.descriptors)

      # If the wrapped command is still running
      if wrapper.running
        wrapper.handle_descriptors_requiring_reading(readable)
      end
    else
      $stdout.write(_errored).inspect
    end
  end
end
