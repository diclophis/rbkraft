#!/usr/bin/env ruby

$: << "."
$: << "../"

require 'diclophis_world_painter'

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

  x, y, z = painter.player_position("diclophis")
  painter.center[0] = x
  painter.center[1] = y
  painter.center[2] = z

  puts [x, y, z].inspect

  ph = 10
  pw = 10
  pd = 10
  bd = 0
  ph.times { |i|
    (pw).times { |x|
      (pd).times { |z|
        painter.place(-x, -bd - i, -z, sand_type)
      }
    }
  }

  sleep 2

#end
