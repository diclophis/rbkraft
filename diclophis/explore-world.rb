#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

srand

oox = 0
ooy = 0
ooz = 0

s = 128

global_painter = DiclophisWorldPainter.new(true, oox, ooy, ooz)
puts "connected"

global_painter.async do
  (-s..s).each { |ttx|
    (-s..s).each { |tty|
      v = 16
      global_painter.place(ttx * v, 0, tty * v, global_painter.bedrock_type)

      #global_painter.place((ttx * v) + 4, 3, (tty * v) + 4, global_painter.air_type)
      #global_painter.place((ttx * v) + 9, 3, (tty * v) + 13, global_painter.lava_type)
      #global_painter.place((ttx * v) + 4, 5, (tty * v) + 4, global_painter.sand_type)
      sleep 0.001

=begin
      v = 7
      z = 3
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
      }
      }
=end

    }
  }
end

puts global_painter.client.command_count

puts "done"
