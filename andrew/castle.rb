#!/usr/bin/env ruby

require_relative '../world-painter/world_painter.rb'

class Castle
  attr_accessor :painter

  def initialize(painter, options = {})
    @painter = painter
  end

  def torches(mod = 2, options = {})
    d = 0
    lambda do |x,y,z|
      d += 1
      if d % mod == 0
        thing = if options[:remove]
                  y+1 <= 0 ? 'water' : 'air'
                else
                  'torch'
                end
        painter.place(x,y+1,z, thing)
      end
    end
  end

  def wall(start_pos, end_pos, options = {})
   height = 5
   width = 3
   ignore = ['torch', 'Stone Brick']

   # rotate 90 degrees CW about y-axis: (x, y, z) -> (-z, y, x)
   start_to_end = end_pos - start_pos
   perp = Vector.new(-1 * start_to_end.z, start_to_end.y, start_to_end.x).normalized

   x = start_pos.x
   z = start_pos.z
   index = 0

   while x != end_pos.x || z != end_pos.z
     baseline = 0

     width.to_i.times do |w|
       px = x + perp.x * w
       pz = z + perp.z * w
       y = painter.ground(px, pz, :ignore => ignore)
       baseline = y if w == 0
       baselined_height = [baseline - y, 0].max + height

       baselined_height.to_i.times do |h|
         painter.place px, y + h, pz, options[:remove] ? 'air' : 'stonebrick'
       end

       if w == 0 || w == width - 1
         if index % 3 == 0
           painter.place px, y + baselined_height, pz, options[:remove] ? 'air' : 'stonebrick'
           painter.place px, y + baselined_height + 1, pz, options[:remove] ? 'air' : 'torch'
         end
       end
     end

     x += 1 if x < end_pos.x
     x -= 1 if x > end_pos.x
     z += 1 if z < end_pos.z
     z -= 1 if z > end_pos.z
     index += 1
    end
  end
end

if __FILE__ == $0
  remove = false

  painter = WorldPainter.new(19_747, 72, 20_031)
  painter = Castle.new(painter, :debug => true)
  painter.wall(Vector.new(0, 0, 0), Vector.new(70, 0, 0), :remove => remove)
  painter.wall(Vector.new(0, 0, 0), Vector.new(0, 0, -50), :remove => remove)
  painter.wall(Vector.new(2, 0, 0), Vector.new(2, 0, 50), :remove => remove)
end
