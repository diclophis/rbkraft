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

oox = 24000
ooy = 63
ooz = 24000

painter = DiclophisWorldPainter.new(oox, ooy, ooz)
puts "connected"
position = painter.player_position("diclophis")
painter.center = position
puts position.inspect
puts "wtf"

s = 87
floors = 32
floors_per_tier = 5
i = 0

ox = 0
oy = 0
oz = 0

=begin
painter.async do
  s.times { |x|
    64.times { |y|
      s.times { |z|
        if ((x + oox) - position.x).abs > 128 || ((y + ooy) - position.y).abs > 128 || ((z + ooz) - position.z).abs > 128
          painter.teleport("diclophis", oox + x + 1, ooy + y + 16, ooz + z + 1)
          painter.execute("/fly diclophis on")
          position = painter.player_position("diclophis")
          sleep 0.5
        end

        painter.place(x, y, z, painter.sandstone_type)
      }
    }
    painter.flush_async
  }
end

exit 0
=end

painter.async do
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
end
