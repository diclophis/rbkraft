#!/usr/bin/env ruby

require_relative '../minecraft-wrapper/client.rb'

# Minecraft block types: http://minecraft-ids.grahamedgecombe.com/
# Id of 0 is delete.
# Data values: http://minecraft.gamepedia.com/Data_values#Leaves

class Vector
  attr_accessor :x, :y, :z

  def initialize(x, y, z, debug = false)
    @x = x
    @y = y
    @z = z
    @debug = debug
  end

  def -(v)
    Vector.new(x - v.x, y - v.y, z - v.z)
  end

  def +(v)
    Vector.new(x + v.x, y + v.y, z + v.z)
  end

  def /(c)
    Vector.new(x/c, y/c, z/c)
  end

  def length
    Math.sqrt(x*x + y*y + z*z)
  end

  def normalized
    self / length
  end

  def abs
    Vector.new(x.abs, y.abs, z.abs)
  end

  def max
    [x, y, z].max
  end

  def round
    Vector.new(x.round, y.round, z.round)
  end
end

class WorldPainter
  def initialize(centerX, centerY, centerZ)
    @center = [centerX, centerY, centerZ]
    @client = MinecraftClient.new
  end

  def place(x, y, z, thing = 'dirt', data = 0, mode = 'replace', data_tag = nil)
    thing = thing.is_a?(String) ? "minecraft:#{thing}" : thing
    set_block_command = "/setblock #{(@center[0] + x).to_i} #{(@center[1] + y).to_i} #{(@center[2] + z).to_i} #{thing} #{data} #{mode} #{data_tag}\n"
    @client.execute_command(set_block_command).tap {|output| puts output if @debug }
  end

  def summon(x, y, z, thing = 'air', data_tag = '')
    # summon_command = "/summon #{(@center[0] + x).to_i} #{(@center[1] + y).to_i} #{(@center[2] + z).to_i} minecraft:#{thing} #{data_tag}\n"
    summon_command = "/summon #{thing} #{(@center[0] + x).to_i} #{(@center[1] + y).to_i} #{(@center[2] + z).to_i} #{data_tag}\n"
    @client.execute_command(summon_command)
  end

  def platform(center_x = 0, center_y = 0, center_z = 0, width = 10, id = 20, data = 0, options = {})
    width.times do |x|
      width.times do |z|
        options[:before_each].call(center_x - width/2 + x, center_y, center_z - width/2 + z) if options[:before_each]
        place center_x - width/2 + x, center_y, center_z - width/2 + z, id, data
        options[:after_each].call(center_x - width/2 + x, center_y, center_z - width/2 + z) if options[:after_each]
      end
    end
  end

  # Bresenham’s line drawing algorithm
  # http://www.cb.uu.se/~cris/blog/index.php/archives/400
  def line(p1, p2, options = {})
    p = p1
    d = p2-p1
    n = d.abs.max
    s = d/n.to_f;
    n.times do
      p = p+s
      (options[:xwidth] || options[:width] || 1).times do |xw|
        (options[:zwidth] || 1).times do |zw|
          (options[:ywidth] || 1).times do |yw|
            id = evaluate(options[:id])
            data = evaluate(options[:data])
            options[:before_each].call(p.x+xw, p.y+yw, p.z+zw) if options[:before_each]
            place p.x+xw, p.y+yw, p.z+zw, id, data
            options[:after_each].call(p.x+xw, p.y+yw, p.z+zw) if options[:after_each]
          end
        end
      end
    end
  end

  def evaluate(something)
    if something.is_a?(Proc)
      something.call || 0
    else
      something || 0
    end
  end
end
