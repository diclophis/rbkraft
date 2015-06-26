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

global_painter = DiclophisWorldPainter.new(oox, ooy, ooz)
puts "connected"
puts global_painter.execute("setworldspawn 0 0 0")
#position = global_painter.player_position("diclophis")
#painter.center = position
#puts position.inspect
#exit

0.times { |ttx|
  0.times { |tty|
    global_painter.execute("tp world,#{ttx * 8},#{(rand * 100.0).to_i},#{tty * 8}")
    puts "."
  }
}

def drop_tower(painter, tx, ty)

painter.execute("tp world,#{tx},#{60 + (rand * 16.0).to_i},#{ty}")
position = Vector.new(tx, 47 + (rand * 12.0), ty) #painter.player_position("faker")
painter.center = position
puts position.inspect

puts "wtf"

s = 20 + (rand * 10.0).to_i
floors = 7 + (rand * 10.0).to_i
floors_per_tier = 2 + (rand * 7.0).to_i
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
      s -= 3
      ox += 0
      oz += 0
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

          painter.place(x + ox, y + oy, z + oz, type) if (rand > 0.8)
        }
      }
      #painter.flush_async
    }

    oy += 7
  }
end

end

5.times { |x|
  5.times { |y|
    drop_tower(global_painter, (x * (25 + rand * 3.0)) - 65, (y * (25 + rand * 3.0)) - 65)
  }
}
