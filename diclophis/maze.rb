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

    @size = 2048
    @unit = 16

    @shapes = {}

    16.times { |i|
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
            when 3
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
    @maze = Theseus::OrthogonalMaze.generate(:width => @size, :height => @size, :braid => 25, :weave => 0, :randomness => 25, :wrap => "xy")
    32.times {
      @maze.sparsify!
    }

    #puts @maze.to_s(:mode => :lines)
  end

  def each_bit(player_position)
    px = ((player_position[0].to_i / @unit) + (@size / 2))
    py = ((player_position[2].to_i / @unit) + (@size / 2))

    wid = 2

    chunks = []

    ((px-wid)..(px+wid)).each do |x|
      ((py-wid)..(py+wid)).each do |y|
        if x >= 0 && x < @size && y >= 0 && y < @size
          chunks << [x, y]
        end
      end
    end

    chunks.shuffle.each do |x, y|
      draw_maze(x, y) { |xx, yy, zz, tt|
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
    #  ((ax)..(ax+(@unit - 1))).each do |dx|
    #    ((ay)..(ay+(@unit - 1))).each do |dy|
    #      (((0))..(@unit - 1)).each do |dz|
    #        yield [dx, dz, dy, :air]
    #      end
    #    end
    #  end
    #elsif (rand > 0.99)
    #  ((ax)..(ax+(@unit - 1))).each do |dx|
    #    ((ay)..(ay+(@unit - 1))).each do |dy|
    #      (((@unit/2))..(@unit - 1)).each do |dz|
    #        yield [dx, dz, dy, :air]
    #      end
    #    end
    #  end
    #else
      3.times do |st|
        @shapes[15].each do |vx, vy, vz|
          yield [(ax + vx), 1 + (vy + (st * 3)), (ay + vz), :air]
        end
      end
    #end

    primary = (cell & Theseus::Maze::PRIMARY)

    if shape = @shapes[primary]
      shape.each do |vx, vy, vz|
        type = begin
          if vy == 0
            :air
          elsif vy == (@unit - 1)
            :upper
          elsif vy > ((@unit / 2) + 1)
            :torch
          else
            #(rand > 0.99) ? :lantern : :stone
            :stone
          end
        end

        if type == :upper
          #type_of_light = ((rand > 0.99) ? :lava : ((rand > 0.8) ? :glow : ((rand > 0.7) ? :beacon : ((rand > 0.6) ? :lantern : :torch))))
          type_of_light = :beacon
          #if (rand > 0.33)
          stagger = (rand * (@unit * 0.5).to_i)
          ((0..(@unit * 2))).to_a.reverse.each do |c|
            yield [(ax + vx), ((vy)-c-stagger) + (0.33 * @unit).to_i, (ay + vz), (c == 0) ? type_of_light : :quartz]
          end
        else
          yield [(ax + vx), (vy), (ay + vz), type]
        end
      end
    else
      puts primary, Theseus::Formatters::ASCII::Orthogonal::UTF8_LINES[primary]
      raise "wtF"
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
      puts [Time.now, pd, global_painter.client.command_count].inspect

      nbt_file = NBTUtils::File.new
      tag = nbt_file.read(pd)

      player_position = tag.find_tag("Pos").payload.to_ary.collect { |t| t.payload.value }

      maze.each_bit(player_position) do |x,y,z,t|
        y += 62 - 7
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
        else
        end
      end
    end

    sleep 0.1
  end
end
