#!/usr/bin/env ruby

require_relative '../world-painter/world_painter.rb'

print "player: "
STDOUT.flush
player = gets.strip
exit unless player.length > 0

speed = 1
p = WorldPainter.new(19_747, 72, 20_000, debug: true)
p.center = p.player_position(player)

puts p.center.inspect

300.times do |i|
  puts p.summon 0, 10, 0, 'PrimedTnt', "{Fuse:#{(rand * 50 + 10).to_i},Motion:[#{rand * speed - speed/2.0},#{(rand * speed) - speed/2.0},#{(rand * speed) - speed/2.0}]}"
end
