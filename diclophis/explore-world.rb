#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

srand

oox = 0
ooy = 0
ooz = 0
s = 256

global_painter = DiclophisWorldPainter.new(oox, ooy, ooz)
puts "connected"

#puts global_painter.execute("setworldspawn 0 65 0")

global_painter.async do
  (-s..s).each { |ttx|
    (-s..s).each { |tty|
      v = 16
      global_painter.place(ttx * v, 1, tty * v, global_painter.bedrock_type)
      global_painter.place((ttx * v) + 8, 1, (tty * v) + 8, global_painter.bedrock_type)
      $stdout.write(".")
      sleep 0.001
    }
  }
end

puts "done"
