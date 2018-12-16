#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

oox = 0
ooy = 54
ooz = 0

#(-242.64511719001678, 91.0, -187.13305104614997

global_painter = DiclophisWorldPainter.new(true, oox, ooy, ooz)
puts "connected"

def pop_input
  begin
    $stdin.readline
  rescue EOFError
    nil
  end
end

global_painter.async do
  line_count = 0
  while input = pop_input
    case line_count
      when 0
      when 1
      when 2
      when 3
    else
      x,z,y = input.strip.split(" ").collect(&:to_i)

      global_painter.place(x, y, z, global_painter.sandstone_type)
    end

    line_count += 1
  end
end

puts global_painter.client.command_count
