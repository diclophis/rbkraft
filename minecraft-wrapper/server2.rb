$: << "."
$: << "./lib"

require 'dynasty'
require 'dynasty_io'
require 'wrapper'

leader, descriptors = Dynasty.server
leader.autoclose = false

puts [:leader, leader, leader.fileno, leader.path, leader.addr].inspect

wrapper = Wrapper.new

if descriptors.empty?
  descriptors = wrapper.create_descriptors
else
  wrapper.load_descriptors(descriptors)
end

puts [:ios, descriptors].inspect

running = true
while running
  select_timeout = 0.001
  selectable_sockets = [leader] + wrapper.selectable_descriptors
  readable, writable, errored = IO.select(selectable_sockets, selectable_sockets, selectable_sockets, select_timeout)

  if readable
    running = Dynasty.rule(leader, wrapper.descriptors) if readable.include?(leader)
    wrapper.handle_descriptors_requiring_reading(readable)
  end
end
