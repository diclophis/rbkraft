#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

srand

#oox = 0
#ooy = 0
#ooz = 0

oox = 42000.0
ooy = 0.0
ooz = 42000.0

global_painter = DiclophisWorldPainter.new(false, oox, ooy, ooz)
puts "connected"

s = 6

global_painter.async do
  (-s..s).each { |ttx|
    (-s..s).each { |tty|
      v = 1
      255.times do |i|
        global_painter.place((ttx * v) + 4, i+1, (tty * v) + 4, global_painter.sandstone_type)
      end
    }
  }
end

puts global_painter.client.command_count

puts "done"
