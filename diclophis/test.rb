#!/usr/bin/env ruby

require './world-painter/world_painter'

painter = WorldPainter.new(10020, 80, 20)

height = 30
x = ARGV[0].to_i

height.times { |i|
  puts painter.place(x, -i, 0, "minecraft:air").inspect
}

#height.times { |i|
#  puts painter.place(x, 0, 0, "minecraft:sand").inspect
#}

#10.times { |i|
#  puts painter.place(x, -i, 0, "minecraft:#{ARGV[1]}").inspect
#}
