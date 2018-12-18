#!/usr/bin/env ruby

$stdout.sync = true

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

MINECRAFT_ROOT="/home/minecraft"
OUT="/home/minecraft/backup/text-output"
SIZE=ARGV[0].to_i
TXT=ARGV[1]

system("openscad -D 'msg=\"#{TXT}\"' --autocenter -o #{OUT}-0.stl openscad/text_sphere.scad") || exit(1)

FOO="-om vn fn"

#MESHARGS="-i resources/shape-${I}.stl -o resources/shape-${I}.obj $FOO -s openscad/$FILTERS"
#MESHARGS_TWO="-i resources/shape-${I}-mid.obj -o resources/shape-${I}.obj $FOO -s openscad/foop.mlx"

system("meshlabserver -i #{OUT}-0.stl -o #{OUT}-1.stl #{FOO}-0.stl -s openscad/foop.mlx") || exit(1)

system("/home/minecraft/voxelizer/build/bin/voxelizer #{SIZE} 8 #{OUT}-1.stl #{OUT}.vox") || exit(1)

#MAVENCRAFT_SERVER="localhost"
#MAVENCRAFT_PORT="25566"

#/home/minecraft/voxelizer/build/test/testVox $OUT.vox | ruby /home/minecraft/voxelize-stl-xinetd/main.rb $SIZE -200 -160 -300
#/home/minecraft/voxelizer/build/test/testVox $OUT.vox | ruby /home/minecraft/voxelize-stl-xinetd/main.rb $SIZE -100 -525 -133
#/home/minecraft/voxelizer/build/test/testVox $OUT.vox | ruby /home/minecraft/voxelize-stl-xinetd/main.rb $SIZE -175 -525 -433 redstone_block

def pop_input(inp)
  begin
    inp.readline
  rescue EOFError
    nil
  end
end

inio = File.open("#{OUT}.vox")

#puts "/var/tmp/mavencraft/backup/shape-#{ii}.vox"
#inio = File.open("/var/tmp/mavencraft/backup/shape-#{ii}.vox")

shape_vox = []
line_count = 0
while input = pop_input(inio)
  case line_count
    when 0
      puts input
    when 1
      puts input
    when 2
      puts input
  else
    x,z,y = input.strip.split(" ").collect(&:to_i)
    y -= (SIZE * 0.333)
    shape_vox << [x,y,-z]
  end

  line_count += 1
end

oox = 0
ooy = 0 # 32 + ???
ooz = 0

global_painter = DiclophisWorldPainter.new(true, oox, ooy, ooz)
puts "connected"

puts shape_vox.first.inspect

global_painter.async do
  shape_vox.each do |x,y,z|
    puts [x,y,z].inspect
    global_painter.place(x, y, z, global_painter.sandstone_type)
  end
end

puts global_painter.client.command_count
