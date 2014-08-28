#!/usr/bin/env ruby

require_relative '../world-painter/world_painter.rb'

def stairs(p, options = {})
  draw = lambda do |line_start, line_end|
    if options[:remove]
      p.line line_start, line_end, :width => 3, :id => 'air', :before_each => lambda { |x,y,z| p.place(x,y+1,z,'air') }
    else
      d = 0
      p.line line_start, line_end, :width => 3, :id => 'wool', :data => lambda { d += 1; d %= 15 ; d }, :after_each => lambda { |x,y,z| d % 3 == 0 && p.place(x,y+1,z,'torch') }
    end
  end

  draw.call Vector.new(-15,0,0), Vector.new(-30,15,-25)
  draw.call Vector.new(-30,15,-25), Vector.new(-30,30,-100)
  draw.call Vector.new(-30,30,-100), Vector.new(90,1,-150)
end

def rails(p, x, y, z, options = {})
  powerSpacing = 6
  length = 500

  if options[:remove]
    p.line Vector.new(x-2, y, z - 1), Vector.new(x + length + 4, y, z - 1), :zwidth => 5, :ywidth => 5, :id => 0
  else
#    p.line Vector.new(x, y, z - 1), Vector.new(x + length, y,     z - 1), :zwidth => 1, :ywidth => 5, :id => 20 # glass wall
#    p.line Vector.new(x, y, z + 3), Vector.new(x + length, y,     z + 3), :zwidth => 1, :ywidth => 5, :id => 20 # glass wall
#    p.line Vector.new(x, y + 4, z), Vector.new(x + length, y + 4, z),     :zwidth => 3, :ywidth => 1, :id => 'glass' # glass ceiling
#    p.line Vector.new(x, y + 1, z), Vector.new(x + length, y + 1, z),     :zwidth => 3, :ywidth => 2, :id => 'air'  # clear the area

    # Floor
    # p.line Vector.new(x, y, z),         Vector.new(x + length, y,     z),     :zwidth => 1, :id => 'stonebrick'
    # c = 0
    # p.line Vector.new(x, y, z + 1),     Vector.new(x + length, y,     z + 1), :zwidth => 1, :id => lambda { c += 1; c % powerSpacing == 0 ? 'double_stone_slab' : 'glowstone' }
    # p.line Vector.new(x, y, z + 2),     Vector.new(x + length, y,     z + 2), :zwidth => 1, :id => 'stonebrick'

    #c = 0
    #p.line Vector.new(x, y + 1, z),     Vector.new(x + length, y + 1, z),     :zwidth => 1, :id => lambda { c += 1; c % powerSpacing == 0 ? 'golden_rail' : 'rail' }, :data => lambda { c % powerSpacing == 0 ? 8 : 1 }
    #c = 0
    #p.line Vector.new(x, y + 1, z + 2), Vector.new(x + length, y + 1, z + 2), :zwidth => 1, :id => lambda { c += 1; c % powerSpacing == 0 ? 'golden_rail' : 'rail' }, :data => lambda { c % powerSpacing == 0 ? 8 : 1 }
     c = 0
     p.line Vector.new(x, y + 1, z + 1), Vector.new(x + length, y + 1, z + 1), :zwidth => 1, :id => lambda { c += 1; c % powerSpacing == 0 ? 'redstone_torch' : 'air' } # torches

    # p.line Vector.new(x, y, z-1), Vector.new(x, y, z + 2), :ywidth => 1, :id => 43, :data => 5
    # p.line Vector.new(x+length, y, z-1), Vector.new(x+length, y, z + 2), :ywidth => 2, :id => 43, :data => 5

    p.summon x + 1, y + 1, z,     'MinecartRideable'
    p.summon x + 1, y + 1, z + 2, 'MinecartRideable'
  end
end

# def branch(len, t)
#   forward = lambda { |l, draw|
#     newPos = pos + (dir.normalized() * l)
#     p.line pos, newPos, :id => 17, :data => 1 if draw
#     pos = newPos
#   }
# 
#   if len > 5
#     forward.call(len, true)
#     t.right(20)
#     branch(len-15,t)
#     t.left(40)
#     branch(len-15,t)
#     t.right(20)
#     forward.call(-len, false)
#   end
# end

def tree(p, x, y, z, options = {})
  trunkWidth = 3
  leafWidth = 5
  height = 20

  height.times do |k|
    if k > height / 2
      if k < height / 2 + height / 4
        leafWidth += 1
      else
        leafWidth -= 1
      end

      if leafWidth > 0 
        leafWidth.times do |i|
          leafWidth.times do |j|
            puts p.place x - leafWidth/2 + i, y + k, z - leafWidth/2 + j, *(options[:remove] ? ['air', 0] : ['leaves', 0])
          end
        end
      end
    end

    if k < height - 3
      trunkWidth.times do |i|
        trunkWidth.times do |j|
          puts p.place x - trunkWidth/2 + i, y + k, z - trunkWidth/2 + j, *(options[:remove] ? ['air', 0] : ['log', 0])
        end
      end
    end
  end
end

p = WorldPainter.new(20_050, 65, 19_960)

tree(p, 10, 0, 10)

# Repair area:
if false
  # p.platform 0, -1, 0, 30, 'diamond_ore'
  # d = 0
  # p.platform 0, 0, 0, 30, 'grass', 0, :after_each => lambda { |x,y,z| d += 1 ; d % 8 == 0 && p.place(x,y+1,z, 'torch') }
  # stairs p, :remove => false
  # p p.place 1,1,0,'chest', 0, 'replace', '{Items:[{id:276,Count:16,Slot:0}]}'
  # tree p, -12, 0, -50, :remove => false
  # rails p, 15, 0, 0, :remove => false
end

# Repair the small sky platform:
# p.platform 0, 30, 0, 5, 20

# Repair the big sky platform:
# p.platform 0, 20, 0, 30, 20
