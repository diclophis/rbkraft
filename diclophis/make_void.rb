#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

srand

oox = 0
ooy = 0
ooz = 0

painter = DiclophisWorldPainter.new(oox, ooy, ooz)
puts "connected"

#painter.async do
#  4.times do |i|
#    (-3..3).each do |l|
#      (-3..3).each do |r|
#        painter.place(oox + l, i, ooz + r, (i < 2) ? painter.bedrock_type : painter.air_type)
#      end
#    end
#  end
#end

#vec3 rgb(float r, float g, float b) {
#  return vec3(r / 255.0, g / 255.0, b / 255.0);
#}

def clamp(x, a, b)
  x = [a,x,b].sort[1]
end

#
# Draw a circle at vec2 `pos` with radius `rad` and
# color `color`.
#
def circle(uv, pos, rad)
  d = ((pos - uv).length - (rad))
  t = clamp(d, 0.0, 1.0)
end

s = 32
v = 16

iResolution = Vector.new((s * v).to_f, (s * v).to_f, 0.0)

center = (iResolution * 0.0) # + Vector.new(0.5, 0.5, 0.0)
radius = 0.2 * iResolution.y

painter.async do
  (-(iResolution.y*0.5).to_i..(iResolution.y*0.5).to_i).each do |y|
    (-(iResolution.x*0.5).to_i..(iResolution.x*0.5).to_i).each do |x|
      uv = Vector.new(x.to_f, y.to_f, 0.0)
      inner = circle(uv, center, radius)
      outer = circle(uv, center, radius + (0.25 * iResolution.y))
      sum = clamp((outer - inner).abs, 0.0, 1.0)
      if sum.to_i == 1
        (256..0).each do |i|
          painter.place(x, i, y, painter.air_type)
        end
        sleep 0.05
      end
    end
    $stdout.write(".") if ((y % 100) == 0)
  end
end
