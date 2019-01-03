#!/usr/bin/env ruby

require 'tempfile'
require 'rexml/document'

xml_data = File.read(ARGV[0]) 
eisenscript_data = File.read(ARGV[1])

doc = REXML::Document.new(xml_data)
doc.elements.each('FilterScript/filter') do |ele|
  ele.elements.each("Param[@name='grammar']") do |pele|
    pele.attributes["value"] = eisenscript_data
  end

  ele.elements.each("Param[@name='seed']") do |pele|
    pele.attributes["value"] = (rand * 10000.0).to_i
  end
end

tmp_mlx = Tempfile.new(["filters", ".mlx"])
tmp_mlx.write(doc.to_s)
tmp_mlx.flush

tmp_stl = Tempfile.new(["rendered-es", ".stl"])

meshlab_eisen_to_stl_cmd = "meshlabserver -i #{tmp_stl.path} -o #{tmp_stl.path} -s #{tmp_mlx.path} 2> /dev/null"

meshlab_output = IO.popen(meshlab_eisen_to_stl_cmd).read

meshlab_output.include?("saved as #{tmp_stl.path}") || exit(1)

#system("cat #{tmp_stl.path}")
tmp_stl.rewind

if ARGV[2]
  File.write(ARGV[2], tmp_stl.read)
else
  $stdout.write(tmp_stl.read)
end

tmp_stl.close
tmp_mlx.close
