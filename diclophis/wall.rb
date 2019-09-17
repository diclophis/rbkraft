#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

srand(1)

#oox = 0
#ooy = 0
#ooz = 0

oox = 0.0
ooy = 0.0
ooz = 0.0

global_painter = DiclophisWorldPainter.new(true, oox, ooy, ooz)
puts "connected"

s = 255

global_painter.async do
  (-s..s).each { |ttx|
    (0..255).each { |tty|
      r = (rand * 3).to_i
      case r
      when 0
        global_painter.place(ttx, tty, 1, global_painter.type)
      when 1
        global_painter.place(ttx, tty, 1, global_painter.lantern_type)
      when 2
        global_painter.place(ttx, tty, 1, global_painter.beacon_type)
      end
    }
  }
end

puts global_painter.client.command_count

puts "done"
