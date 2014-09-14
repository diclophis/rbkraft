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

  #@x=20597
  #@y=106
  #@z=19187

  @x=20567
  @y=130
  @z=18795

  painter.center = Vector.new(@x, @y, @z)
  #painter.center = painter.player_position("diclophis") + Vector.new(-2.0, -2.0, -2.0)

  puts painter.center.inspect

  painter.async do
    ph = 90
    pw = 90
    pd = 90

    c = 0
    ph.times { |i|
      (pw).times { |x|
        (pd).times { |z|
          painter.place(-x, -i, -z, sandstone_type)
          sleep 0.002
        }
        #  c += 1
        #  if (c % 200) == 0
        #    painter.place(-x, 2, -z, sandstone_type)
        #    #puts [-x, @y + 18, -z].inspect
        #    #puts [-x + @y, @y + 19, -z + @z].inspect
        #    painter.teleport("diclophis", -x + @x, @y + 4, -z + @z)
        #  end
        #  #sleep 0.001
      }
    }
  end

#end
