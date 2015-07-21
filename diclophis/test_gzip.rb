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
  painter.place(oox, ooy, ooz, painter.type)
end
