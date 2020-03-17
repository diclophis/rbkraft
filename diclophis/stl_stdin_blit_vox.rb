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
Process.wait rescue Errno::ECHILD

newtmp = File.join(TMPROOT, "#{SIZE}-#{shasum}")

#unless File.exists?(newtmp) && File.exists?("#{newtmp}.vox")
  puts [:copying_and_voxelizing, tmp_stl.path, newtmp].inspect
  FileUtils.copy(tmp_stl.path, newtmp + ".stl")

  system("/usr/bin/binvox -d #{SIZE} -e #{newtmp}.stl") || exit(1)
  Process.wait rescue Errno::ECHILD
#end

tmp_stl.close

system("ruby", "diclophis/binvox2cmd.rb", "#{newtmp}.binvox", X.to_s, Y.to_s, Z.to_s, T.to_s) || exit(1)
Process.wait rescue Errno::ECHILD
