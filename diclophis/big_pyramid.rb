#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

def water_or_tnt(painter)
  #if rand > 0.9
  #  painter.lava_type
  #elsif rand > 0.9
  #  painter.water_type
  #else
    painter.sandstone_type
  #end
end

def mostly_air(painter)
  if rand > 0.5
    painter.air_type
  else
    painter.sand_type
  end
end

painter = DiclophisWorldPainter.new(24000, 71, 24000)
position = painter.player_position("diclophis")
puts position.inspect

s = 64

painter.async do
  s.times { |x|
    s.times { |y|
      s.times { |z|
        #if ((x % 16) > 8) || ((y % 8) > 4) || ((z % 4) > 2)
        if ((x % 16) > 8) || ((y % 8) > 4) || ((z % 4) > 2)
          if ((x % 9) > 7)
            painter.place(x, y - 8, z, water_or_tnt(painter))
          else
            painter.place(x, y - 8, z, mostly_air(painter))
          end
        else
          if ((z % 11) > 9)
            painter.place(x, y - 8, z, water_or_tnt(painter))
          else
            painter.place(x, y - 8, z, mostly_air(painter))
          end
        end
      }
    }
    painter.flush_async
  }
end
