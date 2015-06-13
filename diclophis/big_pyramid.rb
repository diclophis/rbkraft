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
position = painter.player_position("diclophis")
puts position.inspect

s = 87 
i = 0

painter.async do
  s.times { |x|
    i += 1
    s.times { |y|
      s.times { |z|
        if ((y % 7) == 0)
          i += 3
          if ((i % 9) == 0) && (x != 0 && x != (s-1)) && (z != 0 && z != (s-1))
            painter.place(x, y, z, painter.glow_type)
          else
            painter.place(x, y, z, painter.sandstone_type)
          end
        else
          if ((x) == 0) || ((x) == (s-1)) || (z == 0) || (z == (s-1))
            if ((x % 9) > 5) || ((z % 9) > 5)
              painter.place(x, y, z, painter.sandstone_type)
            else
              painter.place(x, y, z, painter.air_type)
            end
          else
            if (((x-7) % 9) == 0) && (((z-7) % 9) == 0)
              painter.place(x, y, z, painter.sandstone_type)
            else
              painter.place(x, y, z, painter.air_type)
            end
          end

=begin
          if ((y % 7) == 0) || ((x % 9) > 5) || ((z % 9) > 5)
            if ((y % 7) == 0) # FLOOR
            elsif (x != 0 && x != (s-1)) && (z != 0 && z != (s-1)) # INSIDE
              #if ((y % 7) == 6)
              #  painter.place(x, y, z, painter.iron_bars_type)
              #elsif ((y % 7) == 5)
              #  painter.place(x, y, z, painter.glass_type)
              #else
                painter.place(x, y, z, painter.air_type)
              #end
            else # OUTER BEAMS
              painter.place(x, y, z, painter.sandstone_type)
            end
          else
            painter.place(x, y, z, painter.air_type)
          end
=end
        #else
        #  painter.place(x, y, z, painter.air_type)
        end
        #if ((x % 16) > 8) || ((y % 8) > 4) || ((z % 4) > 2)
        #if ((x % 16) > 8) || ((y % 8) > 2) || ((z % 4) > 2)
        #  if ((x % 9) > 7)
        #    i += 1
        #    painter.place(x, y - 8, z, water_or_tnt(i, painter))
        #  else
        #    painter.place(x, y - 8, z, mostly_air(painter))
        #  end
        #else
        #  if ((z % 11) > 9)
        #    i += 1
        #    painter.place(x, y - 8, z, water_or_tnt(i, painter))
        #  else
        #    painter.place(x, y - 8, z, mostly_air(painter))
        #  end
        #end
      }
    }
    painter.flush_async
  }
end
