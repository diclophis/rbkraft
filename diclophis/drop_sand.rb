$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

def random_angle
  angle = rand * Math::PI * 2.0
end

def xy_from_angle_radius(angle, radius)
  [Math.cos(angle) * radius, Math.sin(angle) * radius]
end

srand

oox = -1024
ooy = 63
ooz = 1024

painter = DiclophisWorldPainter.new(true, oox, ooy, ooz)

painter.async do
  while true
    $stdout.write(".")
    256.times do |i|
      d = (6 + (rand * 32))
      x,z = xy_from_angle_radius(random_angle, 6 + (rand * 32))
      s = (2.0 - (1.0 + Math.sin(((38.0 - d.to_f) / 38.0))))
      if rand > s
        painter.place(x, -(rand * 32) + 5, z, painter.sand_type)
      end
    end
  end
end
