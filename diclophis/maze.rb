#

$: << "."
$: << "diclophis"

require 'theseus'
require 'diclophis_world_painter'

class Maze
  UTF8_LINES = [" ", "╵", "╷", "│", "╶", "└", "┌", "├", "╴", "┘", "┐", "┤", "─", "┴", "┬", "┼"]

  def initialize
    @size = 256
    @unit = 16

    @shapes = {}

    16.times { |i|
      ii = begin
        case i
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
            0
        else
          nil
        end
      end
      
      if ii
        shape_vox = []
        #inio = File.open("/home/minecraft/shape-#{ii}.vox")
        puts "/var/tmp/mavencraft/backup/shape-#{ii}.vox"

        inio = File.open("/var/tmp/mavencraft/backup/shape-#{ii}.vox")

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
    @maze = Theseus::OrthogonalMaze.generate(:width => @size, :height => @size, :braid => 33, :weave => 0, :wrap => "xy", :sparse => 50)

    puts @maze.to_s(:mode => :lines)
  end

  def each_bit(player_position)
    px = ((player_position[0].to_i / @unit) + (@size / 2))
    py = ((player_position[2].to_i / @unit) + (@size / 2))

    wid = 32

    ((px-wid)..(px+wid)).each do |x|
      ((py-wid)..(py+wid)).each do |y|
        if x >= 0 && x < @size && y >= 0 && y < @size
          draw_maze(x, y) { |xx, yy, zz, tt|
            yield xx, yy, zz, tt
          }
        end
      end
    end
  end

  def draw_maze(x, y) #:nodoc:
    ax = ((x * @unit) - (@size * 0.5 * @unit)).to_i
    ay = ((y * @unit) - (@size * 0.5 * @unit)).to_i

    ((ax)..(ax+@unit)).each do |dx|
      ((ay)..(ay+@unit)).each do |dy|
        (((@unit/2)+1)..(@unit)).each do |dz|
          yield [dx-(0*@unit-1), dz, dy-(1*@unit-1), :air]
        end
      end
    end

    cell = @maze[x, y]
    return if cell == 0

    primary = (cell & Theseus::Maze::PRIMARY)

    puts UTF8_LINES[primary]

    if shape = @shapes[primary]
      shape.each do |vx, vy, vz|
        type = begin
          if vy == 0
            :air
          elsif vy == (@unit - 1)
            :glow
          else
            :stone
          end
        end

        yield [(ax + vx), (vy), (ay + vz), type]
      end
    else
      puts primary, Theseus::Formatters::ASCII::Orthogonal::UTF8_LINES[primary]
      raise "wtF"
    end
  end

  def each_piece(player_position)
    #px = ((player_position[0].to_i / @unit) + (@size / 2))
    #py = ((player_position[2].to_i / @unit) + (@size / 2))
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

#(-242.64511719001678, 91.0, -187.13305104614997

global_painter = DiclophisWorldPainter.new(true, oox, ooy, ooz)
puts "connected"

maze = Maze.new

player_position = [0, 64, 0]

global_painter.async do
  maze.each_bit(player_position) do |x,y,z,t|
    z += 128
    case t
      when :air
        global_painter.place(x, y, z, global_painter.air_type)
      when :stone
        global_painter.place(x, y, z, global_painter.sandstone_type)
      when :glow
        global_painter.place(x, y, z, global_painter.glow_type)
    else
    end
  end

  #maze.each_piece(player_position) do |x,y,z|
  #  global_painter.place(x, y, z, global_painter.sandstone_type)
  #end
end

puts global_painter.client.command_count
