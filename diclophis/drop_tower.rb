$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

#def random_angle
#  angle = rand * Math::PI * 2.0
#end

##Then x = Math.cos(angle)*radius and y = Math.sin(angle)*radius
#def xy_from_angle_radius(angle, radius)
#  [Math.cos(angle) * radius, Math.sin(angle) * radius]
#end

#srand

oox = 24000
ooy = 0
ooz = 24000

a = 0.0
b = 0
r = 0.0
t = 0

painter = DiclophisWorldPainter.new(oox, ooy, ooz)
painter.execute("tp world,0,0,0")

position = painter.player_position("diclophis")
position.y = 0
painter.center = position
puts position.inspect

painter.async do
  while true
    256.times do |i|
      256.times do |j|
        ii = i * 16
        jj = j * 16

        painter.execute("tp world,#{ii},250,#{jj}")
        #painter.execute("spawn") #tp world,#{ii},256,#{jj}")

        position = painter.player_position("diclophis")
        #position.y = 0
        #painter.center = position
        puts position.inspect

        256.times do |k|
          painter.place(ii, k, jj, painter.type)
        end
      end
    end 
  end
end
