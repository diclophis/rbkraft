#!/usr/bin/env ruby

$: << "."
$: << "../"

require 'diclophis_world_painter'

ox = 19900
oy = 63
#63 is water
oz = 19900

#painter = DiclophisWorldPainter.new(ox, oy, oz, { :async_client => false})
#position = painter.player_position("diclophis")
#painter = nil
#puts position.inspect

painter = DiclophisWorldPainter.new(ox, oy, oz, { :async_client => true})

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

  #x, y, z = painter.player_position("diclophis")
  position = [20574.0, 71.0, 19173.0]
  painter.center[0] = (position[0]).to_i
  painter.center[1] = (position[1]).to_i
  painter.center[2] = (position[2]).to_i

  puts position.inspect

  ph = 50
  pw = 110
  pd = 110
  ph.times { |i|
    (pw).times { |x|
      (pd).times { |z|
        painter.place(-x, -i, -z, sandstone_type)
      }
    }
  }

#end
