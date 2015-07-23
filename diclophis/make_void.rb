#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

srand

oox = 0
ooy = 0
ooz = 0

#painter = DiclophisWorldPainter.new(oox, ooy, ooz)
#puts "connected"

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

iResolution = Vector.new(25.0, 25.0, 0.0)

center = iResolution * 0.5
radius = 0.2 * iResolution.y

(0..iResolution.y.to_i).each do |y|
  (0..iResolution.x.to_i).each do |x|
    uv = Vector.new(x.to_f, y.to_f, 0.0)
    #puts [iResolution, uv, center, radius].inspect
    inner = circle(uv, center, radius)
    outer = circle(uv, center, radius + (0.25 * iResolution.y))
    sum = clamp((outer - inner).abs, 0.0, 1.0)
    $stdout.write(sum.to_i.to_s)
  end
  $stdout.write("\n")
end
