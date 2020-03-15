#!/bin/bash

# glass sphere
bash scripts/run-gen-scad.sh openscad/sphere.scad | bash scripts/run-vox-blit.sh 32 -300 128 0 glass

# makes the giant mavencraft logo
#bash scripts/run-gen-text.sh "mavencraft.net" | bash scripts/run-vox-blit.sh 256 0 256 0 obsidian

# wip needs model to be rotated
#cat models/low_drogon-r1.stl | bash scripts/run-vox-blit.sh 128 1024 128 1024 stone

## nyc
#cat models/nyc-no-floor.stl | bash scripts/run-vox-blit.sh 1357 256 679 -256 quartz_block

# serpinski pyramid
#bash scripts/run-gen-synth.sh openscad/structure-synth.mlx eisenscript/pyramid.es | bash scripts/run-vox-blit.sh 279 1024 152 -1024 sandstone
