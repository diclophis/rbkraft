#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'tempfile'
require 'open3'
require 'diclophis_world_painter'

TXT=$stdin.read.strip

tmp_stl = Tempfile.new(["rendered-es", ".stl"])
stdout_str, stderr_str, status = Open3.capture3("openscad", "-D", "msg=\"#{TXT}\"", "--autocenter", "-o", tmp_stl.path, "openscad/text_sphere.scad")
status.success? || exit(1)
tmp_stl.rewind

$stdout.write(tmp_stl.read)
