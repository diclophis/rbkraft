#

$stdout.sync = true

$: << "."
$: << "diclophis"

require 'theseus'
require 'nbt_utils'
require 'diclophis_world_painter'

class Maze
  UTF8_LINES = [" ", "╵", "╷", "│", "╶", "└", "┌", "├", "╴", "┘", "┐", "┤", "─", "┴", "┬", "┼"]

  def initialize
    @drawn = {}

    # how far from player to blit in
    @wid = 3

    # size of map in map coordinate space
    @size = 1024

    # size of map unit in voxel coordinate space
    @unit = 32

    # sea level to match with walking platform
    @sea_level = 63 #4 flat #66 #63 default

    @shapes = {}

    18.times { |i|
      ii = begin
        case i
          when 0
            0
          when 1
            8
          when 2
            7
          when 3
            9
          when 4
            6
          when 5
            12
          when 6
            11
          when 7
            3
          when 8
            5
          when 9
            13
          when 10
            14
          when 11
            4
          when 12
            10
          when 13
            1
          when 14
            2
          when 15
            15
          when 16
            16
          when 17
            17
        else
          nil
        end
      end

      if ii
        shape_vox = []
        inio = File.open("/home/minecraft/shape-#{ii}.vox")

        #puts "/var/tmp/mavencraft/backup/shape-#{ii}.vox"
        #inio = File.open("/var/tmp/mavencraft/backup/shape-#{ii}.vox")

        line_count = 0
        while input = pop_input(inio)
          case line_count
            when 0
            when 1
            when 2
            #when 3
          else
            x,z,y = input.strip.split(" ").collect(&:to_i)
            shape_vox << [x,y,-z]
          end

          line_count += 1
        end

        @shapes[i] = shape_vox
      end
    }

    srand(2)

    # generate a 10x10 orthogonal maze and print it to the console
    @maze = Theseus::OrthogonalMaze.generate(:width => @size, :height => @size, :braid => 0, :weave => 0, :randomness => 100, :wrap => "xy")
    8.times {
      @maze.sparsify!
    }

    #puts @maze.to_s(:mode => :lines)
  end

  def each_bit(player_position)
    px = ((player_position[0].to_i / @unit) + (@size / 2)) - 1
    py = ((player_position[2].to_i / @unit) + (@size / 2)) - 1

    #puts [px, py, @size].inspect

    chunks = []

    ((px-@wid)..(px+@wid)).each do |x|
      ((py-@wid)..(py+@wid)).each do |y|
        if x >= 0 && x < @size && y >= 0 && y < @size
          chunks << [x, y]
        end
      end
    end

    chunks.sort_by { |x,y|
      d = Math.sqrt(((x-px)**2)+((y-py)**2))
      d.abs
    }.each do |x, y|
      draw_maze(x, y) { |xx, yy, zz, tt|
        yy += @sea_level - (@unit / 2)

        yield xx, yy, zz, tt
      }
    end
  end

  def draw_maze(x, y) #:nodoc:
    return if @drawn["#{x}/#{y}"]

    ax = ((x * @unit) - (@size * 0.5 * @unit)).to_i
    ay = ((y * @unit) - (@size * 0.5 * @unit)).to_i

    cell = @maze[x, y]
    return if cell == 0

    #if (rand > 0.99)
    if false
      ((ax)..(ax+(@unit - 1))).each do |dx|
        ((ay)..(ay+(@unit - 1))).each do |dy|
          (((0))..(@unit - 1)).each do |dz|
            yield [dx, dz, dy, :air]
          end
        end
      end
    end

    #elsif (rand > 0.99)
    #  ((ax)..(ax+(@unit - 1))).each do |dx|
    #    ((ay)..(ay+(@unit - 1))).each do |dy|
    #      (((@unit/2))..(@unit - 1)).each do |dz|
    #        yield [dx, dz, dy, :air]
    #      end
    #    end
    #  end
    #else

    if true
      air_or_cat = rand > 0.5 ? :air : :stone
      air_or_cat = :air
      3.times do |st|
        @shapes[15+st].each do |vx, vy, vz|
          yield [(ax + vx), 1 + (vy + (st * 3)), (ay + vz), air_or_cat]
        end
      end
    end

    primary = (cell & Theseus::Maze::PRIMARY)

    if shape = @shapes[primary]
      shape.each do |vx, vy, vz|
        type = begin
          if vy < ((@unit / 2) - 1)
            #:air
            nil
          elsif vy == (@unit - 1)
            :upper
          elsif vy > ((@unit / 2) + 2) # shelf lighting
            :lantern
          elsif vy < ((@unit / 2)) # shelf lighting
            if (vx - (@unit / 2)).abs < 3 || (vz - -(@unit / 2)).abs < 3 #((vx + (@unit / 2)).abs  < 4 && (vz + (@unit / 2)).abs < 4)
              #vy += 1
              :water
            else
              nil #:stone
            end
          else
            #(rand > 0.99) ? :lantern : :stone
            :stone
          end
        end

        if type == :upper
          #type_of_light = ((rand > 0.99) ? :lava : ((rand > 0.8) ? :glow : ((rand > 0.7) ? :beacon : ((rand > 0.6) ? :lantern : :torch))))
          if (rand > ((Math.sin(ax*ay) + 1.0) * 0.5))
            type_of_light = :lantern
            stagger = (rand * (@unit * 0.5).to_i)
            ((0..(@unit * 2))).to_a.reverse.each do |c|
              water_col = ((c == 0) ? type_of_light : ((c == 1) ? :quartz : :quartz))

              yield [(ax + vx), ((vy)-c-stagger) + (0.33 * @unit).to_i, (ay + vz), water_col]
            end
          end
        else
          if type
            yield [(ax + vx), (vy), (ay + vz), type]
          end
        end
      end
    else
      puts primary, Theseus::Formatters::ASCII::Orthogonal::UTF8_LINES[primary]
      raise "unknown map coord"
    end

    @drawn["#{x}/#{y}"] = true
  end

  def each_piece(player_position)
    px = ((player_position[0].to_i))
    pz = ((player_position[2].to_i))

    @shapes.each do |index, shape|
      ax = (index * @unit)
      ay = 0
      az = 64

      shape.each do |vx, vy, vz|
        yield [(ax + vx), (ay + vy), (az + vz)]
      end
    end
  end

  def pop_input(inp)
    begin
      inp.readline
    rescue EOFError
      nil
    end
  end
end

oox = 0
ooy = 0 # 32 + ???
ooz = 0
puts "started"

maze = Maze.new
puts "generated"

global_painter = DiclophisWorldPainter.new(true, oox, ooy, ooz)
puts "connected"

global_painter.async do
  loop do
    Dir["world/playerdata/*dat"].each do |pd|

      nbt_file = NBTUtils::File.new
      tag = nbt_file.read(pd)

      player_position = tag.find_tag("Pos").payload.to_ary.collect { |t| t.payload.value }.collect { |f| f.to_i }

      #puts [Time.now, pd, global_painter.client.command_count, player_position].inspect

      maze.each_bit(player_position) do |x,y,z,t|
        case t
          when :air
            global_painter.place(x, y, z, global_painter.air_type)
          when :stone
            global_painter.place(x, y, z, global_painter.sandstone_type)
          when :glow
            global_painter.place(x, y, z, global_painter.glow_type)
          when :torch
            global_painter.place(x, y, z, global_painter.torch_type)
          when :beacon
            global_painter.place(x, y, z, global_painter.beacon_type)
          when :lantern
            global_painter.place(x, y, z, global_painter.lantern_type)
          when :lava
            global_painter.place(x, y, z, global_painter.lava_type)
          when :quartz
            global_painter.place(x, y, z, global_painter.quartz_type)
          when :water
            global_painter.place(x, y, z, global_painter.water_type)
        else
        end
      end
    end
  end
end
