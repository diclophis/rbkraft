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

painter = DiclophisWorldPainter.new(24000, 71, 24000)
position = painter.player_position("diclophis")
puts position.inspect

s = 64
i = 0

painter.async do
  s.times { |x|
    s.times { |y|
      s.times { |z|
        #if ((x % 16) > 8) || ((y % 8) > 4) || ((z % 4) > 2)
        if ((x % 16) > 8) || ((y % 8) > 2) || ((z % 4) > 2)
          if ((x % 9) > 7)
            i += 1
            painter.place(x, y - 8, z, water_or_tnt(i, painter))
          else
            painter.place(x, y - 8, z, mostly_air(painter))
          end
        else
          if ((z % 11) > 9)
            i += 1
            painter.place(x, y - 8, z, water_or_tnt(i, painter))
          else
            painter.place(x, y - 8, z, mostly_air(painter))
          end
        end
      }
    }
    painter.flush_async
  }
end
