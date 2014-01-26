#!/usr/bin/env ruby

require './diclophis/diclophis_world_painter'

ox = 10050
oy = 63
#63 is water
oz = -50

painter = DiclophisWorldPainter.new(ox, oy, oz)

blocks = Array.new

air_type = "air"
type = air_type
debug_type = air_type
alt_type = air_type
#stair_type = air_type
corner_type = air_type 
slab = air_type 
glass_type = air_type
glow_type = air_type
sand_type = air_type
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
  water_type = "water"
end

x = 0
y = 1
oz = 0
arc_r = 30.0
window_mod = 0

max_arc = 360

last_wall_x = nil
last_wall_z = nil
x = nil
y = nil
z = nil

y = 0
t = 0
top_floor = 7
arc_r = 37.0

if false
  ((top_floor)).times { |f|
    y = top_floor - f
    max_arc.times { |d|
      a = (360 - d).to_f * (Math::PI / 180.to_f)
      arc_r.to_i.times { |r|
        x, z = painter.xy_from_angle_radius(a, r.to_f)
     
        floor_type = air_type
        blocks << [x.to_i, y.to_i, z.to_i, floor_type]
      }
    }
  }

  blocks.uniq!

  blocks.sort_by { |b| b[1] }.reverse.each_with_index { |b, i|
    painter.place(*b)
    if (i % 4000) == 0
      puts "wtf"
      sleep 1
    end
  }
end

arc_r = 30.0
y = 0

floors.times { |f|

  max_arc.times { |d|
    a = d.to_f * (Math::PI / 180.to_f)

    window_mod = 0

    arc_r.to_i.times { |r|
      x, z = painter.xy_from_angle_radius(a, r.to_f)
   
      floor_type = (((window_mod * 2) % 10) == 0) ? glow_type : type

      if r > 9
        blocks << [x.to_i, y.to_i, z.to_i, floor_type]
      end

      window_mod += 1
    }

    x, z = painter.xy_from_angle_radius(a, arc_r.to_f + 0.1)
    blocks << [(x).to_i, y.to_i, z.to_i, type]

    x, z = painter.xy_from_angle_radius(a, arc_r.to_f + 0.33)
    blocks << [(x).to_i, y.to_i, z.to_i, type]

    x, z = painter.xy_from_angle_radius(a, arc_r.to_f + 0.66)
    blocks << [(x).to_i, y.to_i, z.to_i, type]

    x, z = painter.xy_from_angle_radius(a, arc_r.to_f + 0.99)
    blocks << [(x).to_i, y.to_i, z.to_i, type]

    x, z = painter.xy_from_angle_radius(a, arc_r.to_f + 1.0)
    blocks << [(x).to_i, y.to_i, z.to_i, type]

    x, z = painter.xy_from_angle_radius(a, arc_r)

    ny = 0
    per_floor.times { |h|
      should_be_glass = (((((d + t).to_f + (8.0)).to_f / (18).to_f)).to_i % 2)
      wall_type = (should_be_glass == 0) ? water_type : type
      blocks << [(x).to_i, y.to_i + (h + 1), z.to_i, wall_type]
      ny = y.to_i + (h + 1)
    }
  }

  y += per_floor

  arc_r -= 2.0
}

x = 0
oz = 0
arc_r = 5.0

max_arc = (360 * 5) + 4

max_arc.times { |d|
  a = d.to_f * (Math::PI / 180.to_f)

  5.times { |e|
    x, z = painter.xy_from_angle_radius(a, arc_r + e.to_f)

    s = 8.0
    y = (((d % 360).to_f / 360.to_f) * s).to_i + ((d / 360) * s)
    ny = ((((d + 17) % 360).to_f / 360.to_f) * s).to_i + ((d / 360) * s)

    step_type = (y == ny) ? slab : type

    blocks << [x.to_i, y.to_i, z.to_i, step_type]
  }
}

blocks.uniq!

blocks.sort_by { |b| b[1] }.reverse.each_with_index { |b, i|
  painter.place(*b)
  if (i % 4000) == 0
    puts "wtf"
    sleep 1
  end
}
