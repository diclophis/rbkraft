#!/usr/bin/env ruby

require './world-painter/world_painter'

class DiclophisWorldPainter < WorldPainter
  def xy_from_angle_radius(angle, radius)
    [Math.cos(angle) * radius, Math.sin(angle) * radius]
  end
end
