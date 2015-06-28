$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

def random_angle
  angle = rand * Math::PI * 2.0
end

#Then x = Math.cos(angle)*radius and y = Math.sin(angle)*radius
def xy_from_angle_radius(angle, radius)
  [Math.cos(angle) * radius, Math.sin(angle) * radius]
end

srand

oox = 24000
ooy = 63
ooz = 24000

b = 0
a = 0.0
r = 2.0
t = 0

painter = DiclophisWorldPainter.new(oox, ooy, ooz)

painter.async do
  while true
    position = painter.player_position("diclophis")
    painter.center = position
    puts position.inspect
      256.times do |i|
        d = (6 + (rand * 32))
        x,z = xy_from_angle_radius(random_angle, 6 + (rand * 32))
        s = (2.0 - (1.0 + Math.sin(((38.0 - d.to_f) / 38.0))))
        if rand > s
          painter.place(x, -(rand * 32) + 5, z, painter.tnt_type)
        end

        #x,z = xy_from_angle_radius(a, r + 4)
        #t += 1
        #painter.place(x, -(t % 10), z, painter.type)

        #a += 0.001
        #r += 0.1

        #painter.teleport("diclophis", painter.center.x + 1, 256, painter.center.z)
        #painter.execute("/fly diclophis on")
        #sleep 0.001

        #if r > 80 
        #  r = 2.0
        #  b += 3
        #  a = b.to_f
        #end
      end
  end
end
