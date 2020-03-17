#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'tempfile'
require 'diclophis_world_painter'

inp = $stdin.read

tmp_scad = Tempfile.new
tmp_scad.write(inp)
tmp_scad.flush

tmp_stl = Tempfile.new(["rendered-es", ".stl"])
system("openscad", "--autocenter", "-o", tmp_stl.path, tmp_scad.path) || exit(1)
tmp_stl.rewind

$stdout.write(tmp_stl.read)
