#!/usr/bin/env ruby

# generate a orthogonal maze and paints it in the world

require 'theseus'
require './diclophis/diclophis_world_painter'

off = 33
ox = 10000 - off
oy = 62 # 62 is water
oz = 26

max_cell = 1

air_type = "water"
path_type = "grass"

painter = DiclophisWorldPainter.new(ox, oy, oz)

blocks = Array.new

Random.srand #(23412312)

# --width 20 --height 20 --weave 50 --sparse 50 --braid 50

maze = Theseus::OrthogonalMaze.generate({
  :width => 10,
  :height => 15,
  :weave => 0,
  :braid => 20
})

maze.generate!

#100.times { maze.sparsify! }

maze.to_s({:mode => :unicode})

if true
  #puts maze.to_s({:mode => :plain})
  #puts
  puts maze.to_s({:mode => :lines})
  puts
end

#width, height = Theseus::Formatters::ASCII::Orthogonal.dimensions_for(maze, :unicode)
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
    #puts [cell, primary, under, primary & Theseus::Maze::N, primary & Theseus::Maze::E, primary & Theseus::Maze::S, primary & Theseus::Maze::W].inspect
    #cells << cell

    3.times { |wx|
      3.times { |wz| 
        blocks << [ (x * 3) + wx, 0, (z * 3) + wz, air_type]
      }
    }

    case cell
      when 5 #
        # 7#6
        # ##6
        # 445
        blocks << [ (x * 3) + 1, 0, (z * 3) + 0, path_type]
        blocks << [ (x * 3) + 2, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
      when 6 #?
        # aae
        # ##6
        # b#6
        blocks << [ (x * 3) + 2, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]
      when 7
        # aaa
        # ###
        # b#3
        blocks << [ (x * 3) + 1, 0, (z * 3) + 0, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]
        blocks << [ (x * 3) + 2, 0, (z * 3) + 1, path_type]
      when 3 # 3 / 12 swapped
        # 2#6
        # 2#6
        # 2#6
        blocks << [ (x * 3) + 1, 0, (z * 3) + 0, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]
      when 9 #?
        # 2#8
        # 2##
        # d44
        blocks << [ (x * 3) + 1, 0, (z * 3) + 0, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 0, 0, (z * 3) + 1, path_type]
      when 10 #
        # 9aa
        # 2##
        # 2#3
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 0, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]
      when 11
        # 7#8
        # ###
        # 444
        blocks << [ (x * 3) + 1, 0, (z * 3) + 0, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]
        blocks << [ (x * 3) + 0, 0, (z * 3) + 1, path_type]
      when 12 #
        # aaa
        # ###
        # 444
        blocks << [ (x * 3) + 2, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 0, 0, (z * 3) + 1, path_type]
      when 13 # !!!!!!!!
        # 2#8
        # 2##
        # 2#3
        blocks << [ (x * 3) + 1, 0, (z * 3) + 0, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]
        blocks << [ (x * 3) + 0, 0, (z * 3) + 1, path_type]
      when 14 #
        # 7#6
        # ##6
        # b#6
        blocks << [ (x * 3) + 0, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 2, path_type]
        blocks << [ (x * 3) + 2, 0, (z * 3) + 1, path_type]
        blocks << [ (x * 3) + 1, 0, (z * 3) + 1, path_type]
    else
      # blank
    end
  end

  #puts "row"
end

t = 0

blocks.each { |b|

  painter.place(*b)

  if b[3] == path_type && (t % 4) == 0
    painter.place(b[0], b[1] + 1, b[2], "torch")
  end

  t += 1

}
