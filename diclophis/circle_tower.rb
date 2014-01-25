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

if ARGV[0] == "draw"
puts "draw"
  #type = "stone"
  type = "glowstone"
  slab = "stone_slab"
  debug_type = "glowstone"
  alt_type = "stonebrick"
  #stair_type = "air"
  corner_type = "log"
  glass_type = "glass"
end

=begin
b = [0, -2, 0, type]
puts painter.place(*b)

b = [0, -1, 0, type]
puts painter.place(*b)

sleep 10

5.times { |i|
  #b = [0, i, 0, "air"]
  #puts painter.place(*b)

  b = [0, i, 0, "sand"]
  puts painter.place(*b)

  sleep 1

  #b = [0, i - 1, 0, "air"]
  #puts painter.place(*b)
}
=end


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

floors = 2
per_floor = 4

floors.times { |f|
  max_arc.times { |d|
    a = d.to_f * (Math::PI / 180.to_f)

    arc_r.to_i.times { |r|
      x, z = painter.xy_from_angle_radius(a, r.to_f)
      blocks << [x.to_i, y.to_i, z.to_i, type]
    }

    x, z = painter.xy_from_angle_radius(a, arc_r)

    #((((d) % 10) == 0) || (((d) % 11) == 0)) 
    #should_be_wall = true
    #wall_type = should_be_wall ? type : glass_type

    #if wall_type == type || (x.to_i != last_wall_x && z.to_i != last_wall_z)
    #  blocks << [x.to_i, y.to_i + 1, z.to_i, wall_type]
    #end

    #puts ((d / 36) % 2)
    #((((d) % 1) == 0) || (((d) % 2) == 0)) 

    ny = 0
    per_floor.times { |h|
      should_be_glass = (((d.to_f + 8.0).to_f / (18).to_f).to_i % 2)
      #puts [d, (d / 36), (d / 36) % 36, should_be_glass].inspect
      wall_type = (should_be_glass == 0) ? glass_type : type
      #blocks << [(x).to_i, y.to_i + 2, z.to_i, wall_type]
      blocks << [(x).to_i, y.to_i + (h + 1), z.to_i, wall_type]
      ny = y.to_i + (h + 1)
      #y = (h + 1)
    }

    #y = ny 

    #if wall_type == type
    #  last_wall_x = x.to_i
    #  last_wall_z = z.to_i
    #end

    #window_mod += 1
  }

  y += per_floor

  sleep 10
}

blocks.uniq!

#blocks.each { |b|
#  painter.place(*b)
#}

x = 0
oz = 0
arc_r = 5.0

max_arc = 360 * 5

max_arc.times { |d|
  a = d.to_f * (Math::PI / 180.to_f)

  4.times { |e|
    x, z = painter.xy_from_angle_radius(a, arc_r + e.to_f)

    y = (((d % 360).to_f / 360.to_f) * 6.0).to_i + ((d / 360) * 6)
    ny = ((((d + 11) % 360).to_f / 360.to_f) * 6.0).to_i + ((d / 360) * 6)

    step_type = (y == ny) ? slab : type

    blocks << [x.to_i, y.to_i, z.to_i, step_type]

    4.times { |ee|
      blocks << [x.to_i, (y + e).to_i, z.to_i, air_type]
    }
  }
}

blocks.uniq!

blocks.each { |b|
  painter.place(*b)
}
