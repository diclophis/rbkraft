#!/usr/bin/env ruby

require './diclophis/diclophis_world_painter'

ox = 10050
oy = 62
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

floors = 15
winds = floors - 1
upper_step = 22
per_floor = 5

max_arc_r = 20

top_floor = floors * per_floor
arc_r = max_arc_r + 10.0

if false
  ((top_floor + 1)).times { |f|
    y = top_floor - f
    max_arc.times { |d|
      a = (360 - d).to_f * (Math::PI / 180.to_f)
      arc_r.to_i.times { |r|
        x, z = painter.xy_from_angle_radius(a.round, r.to_f)
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

  exit
end

arc_r = max_arc_r
y = 0

lx = x
ly = y
lz = z

floors.times { |f|

  max_arc.times { |d|
    a = (d.to_f + 0.0) * (Math::PI / 180.to_f)
    a_off = 0.0 * (Math::PI / 180.to_f)
    a_inc = 0.0

    r_off = -0.1 

    window_mod = 0

    #((1.0 + Math.sin(d.to_f * 0.055)) * 4.0).to_i
    (arc_r).times { |r|
      if r >= 9
        x, z = painter.xy_from_angle_radius((a + a_inc).to_f, (r.to_f + r_off).to_f)

        1.times {
          floor_type = ((((r + 2)) % 3) == 0) ? glow_type : type

lx = x.round
ly = y.round
lz = z.round

          blocks << [lx, ly, lz, floor_type]
          a_inc += a_off
        }
      end
    }

    #x, z = painter.xy_from_angle_radius(a, arc_r.to_f)

    if true
      #t = -19 
      #should_be_glass = (((((d + t)) / (45))) % 2)
      #(per_floor - 1).times { |h|
      should_be_glass = 1
      1.times { |h|
        wall_type = (should_be_glass == 0) ? air_type : type
        blocks << [lx, ly + (h + 1), lz, wall_type]
      }
    end
  }

  y += per_floor

  #arc_r -= 1
}

x = 0
oz = 0
arc_r = 5.0

max_arc = (360 * winds) + upper_step

if true
  max_arc.times { |d|
    a = d.to_f * (Math::PI / 180.to_f)

    5.times { |e|
      x, z = painter.xy_from_angle_radius(a.to_f, arc_r + e.to_f - 0.8)

      s = 5.0
      y = (((d % 360).to_f / 360.to_f) * s).to_i + ((d / 360) * s)
      ny = ((((d + 33) % 360).to_f / 360.to_f) * s).to_i + ((d / 360) * s)

      step_type = (y == ny) ? slab : type

      blocks << [x.round, y.round, z.round, step_type]
    }
  }
end

blocks.uniq!

blocks.sort_by { |b| b[2] }.each_with_index { |b, i|
  painter.place(*b)
  if (i % 425) == 0
    puts "wtf"
    sleep 0.75
  end
}
