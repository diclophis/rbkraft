#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'tempfile'
require 'diclophis_world_painter'

TXT=ARGV[0]

tmp_stl = Tempfile.new(["rendered-es", ".stl"])
system("openscad", "-D", "msg=\"#{TXT}\"", "--autocenter", "-o", tmp_stl.path, "openscad/text_sphere.scad") || exit(1)
tmp_stl.rewind

$stdout.write(tmp_stl.read)
