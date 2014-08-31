#!/usr/bin/env ruby

$: << "."
$: << "./lib"

require 'dynasty'
require 'dynasty_io'
require 'wrapper'

leader, descriptors = Dynasty.server

wrapper = Wrapper.new(descriptors)

while wrapper.running
  select_timeout = 0.001
  selectable_sockets = [leader] + wrapper.selectable_descriptors
  readable, writable, errored = IO.select(selectable_sockets, selectable_sockets, selectable_sockets, select_timeout)

  if readable
    if readable.include?(leader)
      break unless Dynasty.rule(leader, wrapper.descriptors)
    end

    if wrapper.running
      wrapper.handle_descriptors_requiring_reading(readable)
    end
  end
end
