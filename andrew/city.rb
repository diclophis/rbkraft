#!/usr/bin/env ruby

class City
  attr_accessor :painter, :options

  def initialize(painter, options = {})
    @options = options
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

  def wall(start_pos, end_pos, ground_height, options = {})
    height = 5
    width = 3
    ignore = ['torch', 'Stone Brick']

    # rotate 90 degrees CW about y-axis: (x, y, z) -> (-z, y, x)
    start_to_end = end_pos - start_pos
    perp = Vector.new(-1 * start_to_end.z, start_to_end.y, start_to_end.x).normalized

    x = start_pos.x
    z = start_pos.z
    index = 0

    painter.async do
      while x != end_pos.x || z != end_pos.z
        baseline = 0
      
        width.to_i.times do |w|
          px = x + perp.x * w
          pz = z + perp.z * w
          
          y, _ = painter.ground(px, pz, :ignore => ignore)
          baselined_height = [ground_height - y, 0].max + height

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

  def house(center, opts = {})
    xwidth = opts[:xwidth] || 8
    zwidth = opts[:zwidth] || 10
    height = opts[:height] || 4
    deck = opts.has_key?(:deck) ? opts[:deck] : true
    ground, ground_type = painter.ground(center.x, center.z)

    minx = center.x - xwidth / 2
    maxx = center.x + xwidth / 2
    minz = center.z - zwidth / 2
    maxz = center.z + zwidth / 2
    floory = ground + 1
    ceilingy = floory + height

    # fill open ground
    unless options[:remove]
      minx.upto(maxx) do |x|
        minz.upto(maxz) do |z|
          other_ground, other_ground_type = painter.ground(x, z)
          if other_ground < ground
            other_ground.upto(ground) do |y|
              painter.place(x, y, z, WorldPainter::TYPE_MAPPINGS[other_ground_type])
            end
          end
        end
      end
    end

    painter.async do
      floory.upto(deck ? ceilingy + 2 : ceilingy) do |y|
        minx.upto(maxx) do |x|
          minz.upto(maxz) do |z|
            ladder = (z == center.z && (x == maxx - 1 || x == maxx)) && deck
            door = (z < center.z + 2 && z > center.z - 2 && x == minx && y > floory && y < ceilingy)
            xwall = x == minx || x == maxx
            zwall = z == minz || z == maxz
            type = 'planks'
            if y == floory || (y == ceilingy && !ladder)
              type = 'air' if options[:remove]
              painter.place x, y, z, type
            elsif ladder
              type = x == maxx ? ['planks'] : ['ladder', 4]
              type = ['air'] if options[:remove]
              painter.place x, y, z, *type
            elsif (xwall || zwall) && y > ceilingy + 1
              type = ['fence']
              type = ['air'] if options[:remove]
              painter.place x, y, z, *type
            elsif door
              painter.place x, y, z, 'air'
            elsif xwall
              if z < maxz && z > minz && (z % 3 == 0) && y < ceilingy
                type = 'glass'
              end

              type = 'air' if options[:remove]
              painter.place x, y, z, type
            elsif zwall
              if x < maxx && x > minx && (x % 3 == 0) && y < ceilingy
                type = 'glass'
              end

              type = 'air' if options[:remove]
              painter.place x, y, z, type
            else
              painter.place x, y, z, 'air'
            end
          end
        end
      end
    end
  end
end

if __FILE__ == $0
  require_relative 'andrew.rb'
  
  painter = load_painter

  remove = prompt("Remove?") =~ /^y/i

  city = City.new(painter, remove: remove)

  max_height = -1000
  
  size = 20

  0.upto(size) do |x|
    height = painter.ground(x, 0)[0]
    max_height = height if height > max_height
  end
  
  0.upto(size) do |z|
    height = painter.ground(size, z)[0]
    max_height = height if height > max_height
  end
  
  0.upto(size) do |x|
    height = painter.ground(x, size)[0]
    max_height = height if height > max_height
  end

  0.upto(size) do |z|
    height = painter.ground(0, z)[0]
    max_height = height if height > max_height
  end

  city.wall(Vector.new(0, 0, 0), Vector.new(size, 0, 0), max_height)
  city.wall(Vector.new(size, 0, 0), Vector.new(size, 0, size), max_height)
  city.wall(Vector.new(size, 0, size), Vector.new(0, 0, size), max_height)
  city.wall(Vector.new(0, 0, size), Vector.new(0, 0, 0), max_height)

  # 10.times do
  #   city.house(Vector.new(rand * 50, 0, rand * 50), xwidth: 5 + rand(30), ywidth: 5 + rand(30), height: 3 + rand(15), deck: rand > 0.5)
  # end
end
