#!/usr/bin/env ruby

require_relative '../world-painter/world_painter.rb'

print "x, y, z: "
STDOUT.flush
x, y, z = gets.strip.split(/[^\d]+/).map(&:to_i)
if Vector.new(x,y,z).magnitude < 10_000
  puts "Too close to spawn!"
  exit 1
end

speed = 1
p = WorldPainter.new(x, y, z)

300.times do |i|
  p.summon 0, 10, 0, 'PrimedTnt', "{Fuse:#{(rand * 50 + 10).to_i},Motion:[#{rand * speed - speed/2.0},#{(rand * speed) - speed/2.0},#{(rand * speed) - speed/2.0}]}"
end
