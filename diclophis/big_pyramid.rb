#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

srand

def water_or_tnt(i, painter)
  #if rand > 0.9
  #  painter.lava_type
  #elsif rand > 0.9
  #  painter.water_type
  #else
  if ((i % 64) % 128) == 0
    painter.glow_type
  else
    painter.sandstone_type
  end
end

def mostly_air(painter)
  painter.air_type
end

painter = DiclophisWorldPainter.new(24000, 63, 24000)
puts "connected"
position = painter.player_position("diclophis")
puts position.inspect
puts "wtf"

s = 100 #87
floors = 3
floors_per_tier = 1
i = 0

ox = 0
oy = 0
oz = 0

painter.async do
  s.times { |x|
    s.times { |y|
      s.times { |z|
        #$stdout.write("+")
        painter.place(x, y - 4, z, painter.tnt_type)
        #$stdout.write("-")
      }
    }
    painter.flush_async
  }
end

exit 0

#painter.async do
  floors.times { |f|
    if ((f % floors_per_tier) == (floors_per_tier - 1))
      i = 0
      s -= 19
      ox += 11
      oz += 11
    end
    s.times { |x|
      i += 1
      8.times { |y|
        s.times { |z|
          if ((y % 7) == 0)
            i += 3
            if ((i % 9) == 0) && (x != 0 && x != (s-1)) && (z != 0 && z != (s-1))
              type = painter.glow_type
            else
              type = painter.sandstone_type
            end
          else
            if ((x) == 0) || ((x) == (s-1)) || (z == 0) || (z == (s-1))
              if ((x % 9) > 5) || ((z % 9) > 5)
                type = painter.sandstone_type
              else
                type = painter.air_type
              end
            else
              if (((x-7) % 9) == 0) && (((z-7) % 9) == 0)
                type = painter.sandstone_type
              else
                type = painter.air_type
              end
            end
          end

          painter.place(x + ox, y + oy, z + oz, type)
        }
      }
      #painter.flush_async
    }

    oy += 7
  }
#end
