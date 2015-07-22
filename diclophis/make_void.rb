#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

srand

oox = 0
ooy = 0
ooz = 0

painter = DiclophisWorldPainter.new(oox, ooy, ooz)
puts "connected"

painter.async do
  4.times do |i|
    (-3..3).each do |l|
      (-3..3).each do |r|
        painter.place(oox + l, i, ooz + r, (i < 2) ? painter.bedrock_type : painter.air_type)
      end
    end
  end
end
