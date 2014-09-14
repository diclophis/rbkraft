#!/usr/bin/env ruby

class City
  attr_accessor :painter, :options

  def initialize(painter, options = {})
    @options = options
    @painter = painter
  end

  def house(center, opts = {})
    xwidth = opts[:xwidth] || 8
    zwidth = opts[:zwidth] || 10
    height = opts[:height] || 4
    deck = opts.has_key?(:desk) ? opts[:deck] : true
    ground = painter.ground(center.x, center.y)

    minx = center.x - xwidth / 2
    maxx = center.x + xwidth / 2
    minz = center.z - zwidth / 2
    maxz = center.z + zwidth / 2
    floory = ground + 1
    ceilingy = floory + height

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

  castle = City.new(painter, remove: remove)
  castle.house(Vector.new(0,0,0))
end
