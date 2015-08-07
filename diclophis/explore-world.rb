#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

srand

oox = 0
ooy = 0
ooz = 0
s = 128

global_painter = DiclophisWorldPainter.new(oox, ooy, ooz)
puts "connected"

global_painter.async do
  (-s..s).each { |ttx|
    (-s..s).each { |tty|
      v = 16
      global_painter.place(ttx * v, 1, tty * v, global_painter.bedrock_type)
      global_painter.place((ttx * v) + 8, 1, (tty * v) + 8, global_painter.bedrock_type)
      global_painter.place(ttx * v, 1, tty * v, global_painter.air_type)
      global_painter.place((ttx * v) + 8, 1, (tty * v) + 8, global_painter.air_type)
      $stdout.write(".")
      sleep 0.01
    }
  }
end

puts "done"
