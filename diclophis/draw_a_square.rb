#!/usr/bin/env ruby

$: << "."

require 'world-painter/world_painter'

oox = ARGV[0] || 0
ooy = ARGV[1] || 0
ooz = ARGV[2] || 0

global_painter = WorldPainter.new(oox.to_i, ooy.to_i, ooz.to_i)

tl = Vector.new(-32, 32, -32)
tr = Vector.new(-32, 32, 32)
bl = Vector.new(32, 32, 32)
br = Vector.new(32, 32, -32)

global_painter.async do
  global_painter.line(tl, tr, :id => "sandstone")
  global_painter.line(tl, br, :id => "stone")
  global_painter.line(br, bl, :id => "obsidian")
  global_painter.line(bl, tr, :id => "wool")
end

puts [:total_voxels, global_painter.client.command_count].inspect
