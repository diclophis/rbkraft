#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

srand

oox = 0
ooy = 0
ooz = 0

s = ARGV[0].to_i || 16
h = ARGV[1].to_i || 3
block = ARGV[2] || "grass"

global_painter = DiclophisWorldPainter.new(true, oox, ooy, ooz)

global_painter.async do
  (-s..s).each { |ttx|
    (-s..s).each { |tty|
      v = 4
      global_painter.place(ttx * v, h, tty * v, block)
    }
  }
end

puts global_painter.client.command_count
