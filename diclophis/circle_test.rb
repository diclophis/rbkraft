#!/usr/bin/env ruby

require './diclophis/diclophis_world_painter'

ox = 10030
oy = 63
oz = 50

painter = DiclophisWorldPainter.new(ox, oy, oz)

blocks = Array.new

#50.times { |h|
#  360.times { |i|
#    r = i.to_f * (Math::PI / 180.to_f)
#    y = h
#    x, z = painter.xy_from_angle_radius(r, ((Math.sin(h.to_f * 0.25) + 1.0) * 5.0))
#
#    blocks << [x.to_i, y.to_i, z.to_i, "air"]
#  }
#}

type = "air"
debug_type = "air"
alt_type = "air"
stair_type = "air"

if true
  type = "stone"
  debug_type = "glowstone"
  alt_type = "stonebrick"
  stair_type = "stone_stairs"
end

x = 0
oz = 0
arc_r = 20.5

depth = 3
length = 5

sx = 3
sy = arc_r.ceil
sz = (length * arc_r.ceil * 2)

p [sx, sy, sz].inspect

m = Array.new(sx) { Array.new(sy) { Array.new(sz) { nil } } }

depth.times { |ox| # depth

  length.times { |i| # length

    180.times { |d|

      a = d.to_f * (Math::PI / 180.to_f)

      z, y = painter.xy_from_angle_radius(a, arc_r)

      blocks << [(ox + x).to_i, y.to_i, (oz + z).to_i, type]

    }

    oz += (arc_r * 2) + 1

  }

  oz = 0

}

blocks.uniq!

min = [nil, nil, nil]
max = [nil, nil, nil]

blocks.each { |b|

p [b[0], b[1], b[2] + arc_r.ceil].inspect

  m[b[0]][b[1]][b[2] + arc_r.ceil] = b

  3.times { |i|
    min[i] ||= b[i]
    max[i] ||= b[i]

    if b[i] < min[i]
      min[i] = b[i]
    end

    if b[i] > max[i]
      max[i] = b[i]
    end
  }
}

#3.times { |i|
#  max[i] += 1
#}

#3.times { |i|
#  min[i] -= 1
#}

#puts m[0][0][0].inspect

min[1] -= 1
max[1] += 1

# Z is length

(min[0]..max[0]).each { |x|
  (min[2]..max[2]).each { |z|
    #puts painter.place(x, min[1], z, debug_type)
    blocks << [x, min[1], z, debug_type]

    sy.times { |u|
      # if there is one block above, and only one in either z direction
      if a = m[x][min[1] + 1 + u][z + arc_r.ceil]
        #puts a.inspect
        #puts painter.place(x, min[1], z, alt_type)

        #m[x][min[1] + u][z + arc_r.ceil + 1] || m[x][min[1] + u][z + arc_r.ceil - 1] 
        f = m[x][min[1] + u][z + arc_r.ceil + 1]
        n = m[x][min[1] + u][z + arc_r.ceil - 1]

        if f || n
          #4/5 interesting
          # 6 is good for far
          # 7 is good for near
          blocks << [x, min[1] + u, z, stair_type, f ? 6 : 7]
        #else
        #  blocks << [x, min[1] + u, z, "air"] #not stairs
        end

        break
      end
    }
  }
}

#puts painter.place(min[0], min[1], min[2], debug_type)
#puts painter.place(max[0], max[1], max[2], debug_type)

#blocks << [min[0], min[1], min[2], debug_type]
#blocks << [max[0], max[1], max[2], debug_type]

#blocks.uniq!

blocks.each { |b|
  puts painter.place(*b)
}


