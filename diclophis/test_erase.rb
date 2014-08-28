#!/usr/bin/env ruby

require './diclophis/diclophis_world_painter'

ox = 19900
oy = 63
#63 is water
oz = 19900

painter = DiclophisWorldPainter.new(ox, oy, oz)

blocks = Array.new

air_type = "air"
type = air_type
debug_type = air_type
alt_type = air_type
corner_type = air_type 
slab = air_type 
glass_type = air_type
glow_type = air_type
sand_type = air_type
sandstone_type = air_type
water_type = air_type

if ARGV[0] == "draw"
  puts "draw"
  type = "stone"
  glow_type = "glowstone"
  slab = "stone_slab"
  debug_type = "glowstone"
  alt_type = "stonebrick"
  corner_type = "log"
  glass_type = "glass"
  sand_type = "sand"
  sandstone_type = "sandstone"
  water_type = "water"
end

#while true do

  x, y, z = painter.player_position
  painter.center[0] = x
  painter.center[1] = y
  painter.center[2] = z

  puts [x, y, z].inspect

  #puts painter.place(0, , 0, type)

=begin
  painter = DiclophisWorldPainter.new(x, y - 2, z)

  ph = rand(10) + 10
  pw = rand(7) + 10
  pd = rand(5) + 10
  bd = 10
  ph.times { |i|
    (pw).times { |x|
      (pd).times { |z|
        puts painter.place(-x, -i, -z, type)
      }
    }
  }

  sleep 2
=end
#end
