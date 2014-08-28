#!/usr/bin/env ruby

# generate a orthogonal maze and paints it in the world

$: << "../"
$: << "../../"

require 'theseus'
require 'diclophis_world_painter'

ox = 20000
oy = 64
oz = 20000

max_cell = 1

air_type = "air"
type = air_type
debug_type = air_type
alt_type = air_type
corner_type = air_type 
slab = air_type 
glass_type = air_type
glow_type = air_type
sand_type = air_type
sandstone_type = air_type
water_type = air_type
path_type = air_type
torch_type = air_type

if ARGV[0] == "draw"
  puts "draw"
  type = "stone"
  glow_type = "glowstone"
  slab = "stone_slab"
  debug_type = "glowstone"
  alt_type = "stonebrick"
  corner_type = "log"
  glass_type = "glass"
  sand_type = "sand"
  sandstone_type = "sandstone"
  water_type = "water"
  path_type = "grass"
  torch_type = "torch"
end

painter = DiclophisWorldPainter.new(ox, oy, oz)
x, y, z = painter.player_position("diclophis")
painter.center[0] = x
painter.center[1] = y
painter.center[2] = z

blocks = Array.new

if false
  seed = 1387921741
  puts seed
  Random.srand(seed)
else
  Random.srand
end

maze = Theseus::OrthogonalMaze.generate({
  :width => 10,
  :height => 15,
  :weave => 0,
  :braid => 40
})

maze.generate!

#50.times { maze.sparsify! }

if true
  puts maze.to_s({:mode => :lines})
  puts
end

width, height = Theseus::Formatters::ASCII::Orthogonal.dimensions_for(maze, :lines)

cell_count = 0

cells = [width, height]

maze.height.times do |z|
  length = maze.row_length(z)
  length.times do |x|
    break if cell_count > max_cell

    cell = maze[x, z]
    primary = cell & Theseus::Maze::PRIMARY
    under = cell >> Theseus::Maze::UNDER_SHIFT

    3.times { |wx|
      3.times { |wz|
        #blocks << [ (x * 3) + wx, 2, (z * 3) + wz, air_type]
        blocks << [ (x * 3) + wx, 1, (z * 3) + wz, air_type]
        blocks << [ (x * 3) + wx, 0, (z * 3) + wz, water_type]
        #blocks << [ (x * 3) + wx, -1, (z * 3) + wz, water_type]
      }
    }

    case cell

##### elbow
      when 5
        # 7#6
        # ##6
        # 445
        blocks << [ (x * 3) + 1, 0, (z * 3) + 0, path_type]
        blocks << [ (x * 3) + 2, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
      when 6
        # aae
        # ##6
        # b#6
        blocks << [ (x * 3) + 2, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]
      when 9
        # 2#8
        # 2##
        # d44
        blocks << [ (x * 3) + 1, 0, (z * 3) + 0, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 0, 0, (z * 3) + 1, path_type]
      when 10
        # 9aa
        # 2##
        # 2#3
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 0, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]
##### elbow

##### t
      when 7
        # aaa
        # ###
        # b#3
        blocks << [ (x * 3) + 1, 0, (z * 3) + 0, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]
        blocks << [ (x * 3) + 2, 0, (z * 3) + 1, path_type]
      when 11
        # 7#8
        # ###
        # 444
        blocks << [ (x * 3) + 1, 0, (z * 3) + 0, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]
        blocks << [ (x * 3) + 0, 0, (z * 3) + 1, path_type]
      when 13
        # 2#8
        # 2##
        # 2#3
        blocks << [ (x * 3) + 0, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 2, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 0, path_type]
      when 14
        # 7#6
        # ##6
        # b#6
        blocks << [ (x * 3) + 0, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]
        blocks << [ (x * 3) + 2, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
##### t

##### row
      when 3
        # 2#6
        # 2#6
        # 2#6
        blocks << [ (x * 3) + 1, 0, (z * 3) + 0, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]
      when 12
        # aaa
        # ###
        # 444
        blocks << [ (x * 3) + 2, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 0, 0, (z * 3) + 1, path_type]
##### row

##### cross
      when 15
        # a#a
        # ###
        # a#a
        blocks << [ (x * 3) + 1, 0, (z * 3) + 0, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]

        blocks << [ (x * 3) + 2, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 0, 0, (z * 3) + 1, path_type]
##### cross

    else
      # blank
    end
  end
end

t = 0

blocks.each { |b|

  painter.place(*b)

  if b[3] == path_type 
    if (t % 4) == 0
      painter.place(b[0], b[1] + 1, b[2], torch_type)
    end
  
    t += 1
  end

}
