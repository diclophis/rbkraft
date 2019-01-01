#!/usr/bin/env ruby

$stdout.sync = true

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

TMPROOT="/var/tmp"
MINECRAFT_ROOT="/home/minecraft"
OUT="/home/minecraft/backup/text-output"
SIZE=ARGV[0].to_i
TXT=ARGV[1]

system("openscad -D 'msg=\"#{TXT}\"' --autocenter -o #{OUT}-0.stl openscad/text_sphere.scad") || exit(1)
system

