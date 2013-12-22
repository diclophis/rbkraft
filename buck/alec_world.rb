#!/usr/bin/env ruby

require_relative '../world-painter/world_painter.rb'

DEFAULT_BLOCK = "grass"
X = 9997
Y = 63
Z = 117

class Cursor
	def initialize(x,y,z)
		@painter = WorldPainter.new(x, y, z)
		@location = {:x => 0, :y => 0, :z => 0}
	end

	def x
		@location[:x]
	end

	def y
		@location[:y]
	end

	def z
		@location[:z]
	end

	def x=(new_x)
		@location[:x] = new_x
	end

	def y=(new_y)
		@location[:y] = new_y
	end

	def z=(new_z)
		@location[:z] = new_z
	end

  def place(id = DEFAULT_BLOCK)
    #sleep 0.3
    @painter.place x, y, z, id
  end

  def platform(options = {})
    id = options[:id] || DEFAULT_BLOCK
    width = options[:width] || 10
    #height = options[:height] || 1
    data = options[:data] || 0

    @painter.platform(x, y, z, width, id, data)
  end

  def reset_location
    @location = {:x => 0, :y => 0, :z => 0}
  end
end

c = Cursor.new(X,Y,Z)

pathway = lambda do |destroy = false|
  50.times do
    c.z += 1
    3.times do
      c.x -= 1
      p "x:#{c.x} z: #{c.z} y: #{c.y}"
      destroy ? c.place("air") : c.place
    end
    c.y += 1
    destroy ? c.place("air") : c.place("torch")
    c.y -= 1
    c.x += 3
  end

  c.reset_location
end

#pathway.(false)
#c.platform(:id => "grass")

basic_building = lambda do |destroy = false|
  id = destroy ? "double_stone_slab" : "air"
  10.times do
    7.times do
      c.place(id)
      c.z -= 1
    end

    7.times do
      c.place(id)
      c.x += 1
    end

    7.times do
      c.place(id)
      c.z += 1
    end

    7.times do
      c.place(id)
      c.x -= 1
    end

    c.y += 1
  end
end

# todo:
#2.times do
#  build <<-plan
#    xxxxx  xxxxx
#    x          x
#    x          x
#    x          x
#    x          x
#    x          x
#    xxxxxxxxxxxx
#  plan
#end
#
#8.times do
#  build <<-plan
#    xxxxxxxxxxxx
#    x          x
#    x          x
#    x          x
#    x          x
#    x          x
#    xxxxxxxxxxxx
#  plan
#end