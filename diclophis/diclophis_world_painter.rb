#!/usr/bin/env ruby

require './world-painter/world_painter'

class DiclophisWorldPainter < WorldPainter
  def xy_from_angle_radius(angle, radius)
    [Math.cos(angle) * radius, Math.sin(angle) * radius]
  end

  def player_position
    position = []
    execute("getpos diclophis")
    while line = @client.gets
      [:x, :y, :z].each do |c|
        position << (line.split(" ")[3].gsub(",", "")).to_f if line.include?(c.to_s.upcase + ": ")
      end
      break if line.include?("Pitch")
    end

    position
  end
end
