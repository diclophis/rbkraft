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
  length = 300 # was 500

  if options[:remove]
    p.line Vector.new(x-2, y, z - 1), Vector.new(x + length + 4, y, z - 1), :zwidth => 5, :ywidth => 5, :id => 'air'
  else
    p.line Vector.new(x, y, z - 1), Vector.new(x + length, y,     z - 1), :zwidth => 1, :ywidth => 5, :id => 'glass' # glass wall
    p.line Vector.new(x, y, z + 3), Vector.new(x + length, y,     z + 3), :zwidth => 1, :ywidth => 5, :id => 'glass' # glass wall
    p.line Vector.new(x, y + 4, z), Vector.new(x + length, y + 4, z),     :zwidth => 3, :ywidth => 1, :id => 'glass' # glass ceiling
    p.line Vector.new(x, y + 1, z), Vector.new(x + length, y + 1, z),     :zwidth => 3, :ywidth => 3, :id => 'air'  # clear the area

    # Floor
    p.line Vector.new(x, y, z),         Vector.new(x + length, y,     z),     :zwidth => 1, :id => 'stonebrick'
    c = 0
    p.line Vector.new(x, y, z + 1),     Vector.new(x + length, y,     z + 1), :zwidth => 1, :id => lambda { c += 1; c % powerSpacing == 0 ? 'double_stone_slab' : 'glowstone' }
    p.line Vector.new(x, y, z + 2),     Vector.new(x + length, y,     z + 2), :zwidth => 1, :id => 'stonebrick'

    c = 0
    p.line Vector.new(x, y + 1, z),     Vector.new(x + length, y + 1, z),     :zwidth => 1, :id => lambda { c += 1; c % powerSpacing == 0 ? 'golden_rail' : 'rail' }, :data => lambda { c % powerSpacing == 0 ? 8 : 1 }
    c = 0
    p.line Vector.new(x, y + 1, z + 2), Vector.new(x + length, y + 1, z + 2), :zwidth => 1, :id => lambda { c += 1; c % powerSpacing == 0 ? 'golden_rail' : 'rail' }, :data => lambda { c % powerSpacing == 0 ? 8 : 1 }
    c = 0
    p.line Vector.new(x, y + 1, z + 1), Vector.new(x + length, y + 1, z + 1), :zwidth => 1, :id => lambda { c += 1; c % powerSpacing == 0 ? 'redstone_torch' : 'air' } # torches

    p.line Vector.new(x, y, z-1), Vector.new(x, y, z + 2), :ywidth => 1, :id => 'double_stone_slab'
    p.line Vector.new(x+length, y, z-1), Vector.new(x+length, y, z + 2), :ywidth => 2, :id => 'double_stone_slab'

    puts p.summon x + 1, y + 1, z,     'MinecartRideable'
    puts p.summon x + 1, y + 1, z + 2, 'MinecartRideable'
  end
end

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