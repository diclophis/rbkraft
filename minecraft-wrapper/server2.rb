#!/usr/bin/env ruby

$: << File.dirname(__FILE__)
$: << File.dirname(__FILE__) + '/lib'

require 'dynasty'
require 'wrapper'

leader, descriptors = Dynasty.server(ENV["DYNASTY_SOCK"] || "/tmp/dynasty.sock", ENV["DYNASTY_FORCE"])

wrapper = Wrapper.new(descriptors)

while wrapper.running
  selectable_sockets = [leader] + wrapper.selectable_descriptors
  readable, _writable, _errored = IO.select(selectable_sockets, nil, selectable_sockets, ENV["SELECT_TIMEOUT"] || (1.0 / 60.0))

  if readable
    if readable.include?(leader)
      break unless Dynasty.rule(leader, wrapper.descriptors)
    end

    if wrapper.running
      wrapper.handle_descriptors_requiring_reading(readable)
    end
  end
end
