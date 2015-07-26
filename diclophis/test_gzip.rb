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

center = painter.player_position("diclophis")
puts center

painter.async do
  256.times do
    painter.place(oox, ooy, ooz, painter.type)
  end
end
