#!/usr/bin/env ruby

$stdout.sync = true

$: << "."
$: << "diclophis"

require 'tempfile'
require 'diclophis_world_painter'

TMPROOT="/var/tmp"
MINECRAFT_ROOT="/home/minecraft"
SIZE=ARGV[0].to_i
X=ARGV[1].to_i
Y=ARGV[2].to_i
Z=ARGV[3].to_i
T=ARGV[4]

inp = $stdin.read
puts inp.length
tmp_stl = Tempfile.new
tmp_stl.write(inp)
tmp_stl.flush

puts tmp_stl.path
shasum = IO.popen("shasum #{tmp_stl.path}").read.split(" ")[0]

newtmp = File.join(TMPROOT, "#{SIZE}-#{shasum}.stl")

unless File.exists?(newtmp) && File.exists?("#{newtmp}.vox")
  puts [:copying_and_voxelizing, tmp_stl.path, newtmp].inspect
  FileUtils.copy(tmp_stl.path, newtmp)
  system("ls -l #{TMPROOT}")

  system("meshlabserver -i #{newtmp} -o #{newtmp}-1.stl -s openscad/foop-normalized-y.mlx") || exit(1)
  system("/home/minecraft/voxelizer/build/bin/voxelizer #{SIZE} 4 #{newtmp}-1.stl #{newtmp}.vox") || exit(1)
end

tmp_stl.close

def pop_input(inp)
  begin
    inp.readline
  rescue EOFError
    nil
  end
end

puts [:vox2ruby, newtmp].inspect
inio = File.open("#{newtmp}.vox")

min_x = max_x = min_y = max_y = min_z = max_z = nil
bit_a = bit_b = bit_c = nil

shape_vox = []
line_count = 0
while input = pop_input(inio)
  case line_count
    when 0
      bit_a = input.to_i
    when 1
      bit_b = input.split(" ").collect(&:to_f)
    when 2
      bit_c = input.to_f
  else
    #x,z,y = input.strip.split(" ").collect(&:to_i)
    x,y,z = input.strip.split(" ").collect(&:to_i)

    min_x ||= x
    min_y ||= y
    min_z ||= z
    max_x ||= x
    max_y ||= y
    max_z ||= z

    if x < min_x
      min_x = x
    end
    if x > max_x
      max_x = x
    end
    if y < min_y
      min_y = y
    end
    if y > max_y
      max_y = y
    end
    if z < min_z
      min_z = z
    end
    if z > max_z
      max_z = z
    end

    #z = -z

    #shape_vox << [x,y,z]
    shape_vox.unshift [x,y,z]
  end

  line_count += 1
end

oox = -min_x + X - (((max_x - min_x) * 0.5))
ooy = -min_y + Y + 128 - ((((max_y - min_y) * 0.5))) #((bit_b[1] * ((max_y - min_y)))) #- (bit_b[1] * SIZE))
ooz = -min_z + Z - (((max_z - min_z) * 0.5))

#[:bit, 512, [-1.92312, -1.92312, -1.92312], 0.00450916]
#[:minmax, 0, 37, 290, 511, 245, 283]
#[:ooo, 82, -856.63744, 119]


#[:bit, 32, [-0.5001, -0.5001, -0.5001], 0.0312563]
#[:minmax, 0, 31, 0, 31, 0, 31]
#[:ooo, -15, -16.0032, 15]

puts [:bit, bit_a, bit_b, bit_c].inspect
puts [:minmax, min_x, max_x, min_y, max_y, min_z, max_z].inspect
puts [:ooo, oox, ooy, ooz].inspect

#/tmp/20181224-1825-aju67d
#[:bit, "32\n", "-0.5001 -0.5001 -0.5001\n", "0.0312563\n"]
#[:minmax, 0, 31, 0, 31, -31, 0]
#[0, 0, 0]

global_painter = DiclophisWorldPainter.new(true, oox, ooy, ooz)
puts "connected"

global_painter.async do
  shape_vox.each do |x,y,z|
    if (y+ooy) > 3 && (y+ooy) < 253
      if false #rand > 0.9
        global_painter.place(x, y, z, global_painter.tnt_type)
      else
      #if rand > 0.99
      #  global_painter.place(x, y, z, global_painter.lantern_type)
      #else
        global_painter.place(x, y, z, T)
        #global_painter.place(x, y, z, global_painter.glow_type)
        #global_painter.place(x, y, z, global_painter.sandstone_type)
        #global_painter.place(x, y, z, global_painter.quartz_type)
        #global_painter.place(x, y, z, global_painter.obsidian_type)
      end
    end
  end
end

puts global_painter.client.command_count
