#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'tempfile'
require 'diclophis_world_painter'

SCAD=ARGV[0]

tmp_stl = Tempfile.new(["rendered-es", ".stl"])
system("openscad", "--autocenter", "-o", tmp_stl.path, SCAD) || exit(1)
tmp_stl.rewind

$stdout.write(tmp_stl.read)
