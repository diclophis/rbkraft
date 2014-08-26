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

ph = 60
pw = ph * 2
pd = ph * 2
bd = 10

ph.times { |i|
  (pw - (i * 2)).times { |x|
    (pd - (i * 2)).times { |z|
      puts painter.place(-x - i, i - bd, -z - i, sandstone_type)
    }
  }
}
