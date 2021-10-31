#!/usr/bin/env ruby

require 'tempfile'
require 'rexml/document'

xml_data = File.read(ARGV[0]) 
debug = ARGV[1] == "debug"

eisenscript_data = $stdin.read

doc = REXML::Document.new(xml_data)
doc.elements.each('FilterScript/filter') do |ele|
  ele.elements.each("Param[@name='grammar']") do |pele|
    pele.attributes["value"] = eisenscript_data
  end

  ele.elements.each("Param[@name='seed']") do |pele|
    pele.attributes["value"] = (rand * 10.0).to_i
  end
end

tmp_mlx = File.new("/tmp/#{rand}-filters.mlx", "a+")
tmp_mlx.write(doc.to_s)
tmp_mlx.flush
tmp_mlx.close

tmp_stl = "/tmp/#{rand}-rendered-es.stl"
FileUtils.touch(tmp_stl)

meshlab_eisen_to_stl_cmd = "meshlabserver -o #{tmp_stl} -s #{tmp_mlx.path} #{debug ? "" : '2> /dev/null'}"

meshlab_output = IO.popen(meshlab_eisen_to_stl_cmd).read

if debug
  puts meshlab_eisen_to_stl_cmd
  puts meshlab_output
  exit 2
end

#meshlab_output.include?("saved as #{tmp_stl}") || exit(1)

#tmp_stl.rewind

#if ARGV[2]
#  File.write(ARGV[2], tmp_stl.read)
#else
  $stdout.write(File.read(tmp_stl))
#end
