#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

srand

oox = 0
ooy = 0
ooz = 0
s = 140

global_painter = DiclophisWorldPainter.new(true, oox, ooy, ooz)
puts "connected"

global_painter.async do
  (-s..s).each { |ttx|
    (-s..s).each { |tty|
      v = 8
      z = 1
      (-z..z).each { |ttzx|
      (-z..z).each { |ttzy|
      #global_painter.place(ttx * v, 1, tty * v, global_painter.bedrock_type)
      global_painter.place(ttx * v, 120, tty * v, global_painter.air_type)
      #global_painter.place(ttx * v, 1, tty * v, global_painter.bedrock_type)
      #global_painter.place((ttx * v) + ttzx, 1, (tty * v) + ttzy, global_painter.bedrock_type)
      #global_painter.place((ttx * v) + 8, 1, (tty * v) + 8, global_painter.air_type)
      #global_painter.place((ttx * v) - 8, 1, (tty * v) - 8, global_painter.bedrock_type)
      #global_painter.place((ttx * v) - 8, 1, (tty * v) - 8, global_painter.air_type)
      #global_painter.place((ttx * v) - 8, 1, (tty * v) + 8, global_painter.bedrock_type)
      #global_painter.place((ttx * v) - 8, 1, (tty * v) + 8, global_painter.air_type)
      #global_painter.place((ttx * v) - 8, 1, (tty * v) + 8, global_painter.bedrock_type)
      #global_painter.place((ttx * v) - 8, 1, (tty * v) + 8, global_painter.air_type)
      #$stdout.write(".")
      sleep 0.0000001
      }
      }
    }
  }
end

puts "done"
