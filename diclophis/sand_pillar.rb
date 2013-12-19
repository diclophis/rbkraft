#!/usr/bin/env ruby

sleep 3

OX = 10000
OY = 80
OZ = 0

$OX = 0
$OY = 0
$OZ = 0

$render_pillar = true
$render_torches = true
$render_stone = true

AIR = "minecraft:air"
WOOD = "minecraft:log"
SAND = "minecraft:sand"
TORCH = "minecraft:torch"
STONE = "minecraft:stonebrick"

RAY_COUNT = 700
UP_STEPS = 5
TORCH_RAY_COUNT = 4

def debug(*args)
  $stderr.write((args).collect { |a| a.inspect }.join(", ") + $/)
  $stderr.flush
end

def offset(x, y, z)
  $OX += x
  $OY += y
  $OZ += z
end

def blit(*args)
  $stdout.write([:sh, :place, (args[0] + $OX).round, (args[1] + $OY).round, (args[2] + $OZ).round, args[3], 0, :replace].join(" ") + $/)
  $stdout.flush
end

def random_angle
  angle = rand * Math::PI * 2.0
  #Then x = Math.cos(angle)*radius and y = Math.sin(angle)*radius
end

def xy_from_angle_radius(angle, radius)
  [Math.cos(angle) * radius, Math.sin(angle) * radius]
end

10.times { |d|
  offset -40, 0, 0

  RAY_COUNT.times { |r|
    #a = random_angle
    a = r.to_f + (rand * 1.1) #((i.to_f / 24.0) * 360.0)

    UP_STEPS.times { |u|
      x, z = xy_from_angle_radius(a, (u + 1))
      blit OX + x, OY - u * 2, OZ + z, SAND
    }

    UP_STEPS.times { |u|
      x, z = xy_from_angle_radius(a, ((u) + 1) + UP_STEPS + 1)
      blit OX + x, (OY - (UP_STEPS * 2)) - u, OZ + z, SAND
    }
  } if $render_pillar

  TORCH_RAY_COUNT.times { |i|
    a = ((i.to_f / TORCH_RAY_COUNT.to_f) * 360.0)
    UP_STEPS.times { |u|
      x, z = xy_from_angle_radius(a, (u + 2))
      blit OX + x, OY - (u * 2) - 1, OZ + z, TORCH
    }
  } if $render_torches

  [STONE].each { |t|
    11.times { |h|
      12.times { |r|
        a = (((r.to_f) / 12.to_f) * 370.0)
        x, z = xy_from_angle_radius(a, (1.0))
        blit OX + x, (OY + 1) + h, OZ + z, t
      }
    }
  } if $render_stone
}
