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

ruling = true
while ruling
  select_timeout = 0.001
  selectable_sockets = [leader] + wrapper.descriptors
  readable, writable, errored = IO.select(selectable_sockets, selectable_sockets, selectable_sockets, select_timeout)

  readable && readable.each do |needs_reading|
    case needs_reading
      when leader
        ruling = Dynasty.rule(leader, descriptors)
    end
  end
end
