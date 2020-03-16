#!/bin/bash

## glass sphere
bash scripts/run-gen-scad.sh openscad/sphere.scad | bash scripts/run-vox-blit.sh 32 -1024 128 1024 glass
bash scripts/run-gen-scad.sh openscad/sphere.scad | bash scripts/run-vox-blit.sh 32 1024 128 -1024 glass
bash scripts/run-gen-scad.sh openscad/sphere.scad | bash scripts/run-vox-blit.sh 32 -1024 128 -1024 glass
bash scripts/run-gen-scad.sh openscad/sphere.scad | bash scripts/run-vox-blit.sh 32 1024 128 1024 glass

## makes the giant mavencraft logo
bash scripts/run-gen-text.sh "mavencraft.net" | bash scripts/run-vox-blit.sh 345 0 225 0 obsidian

## dragon
cat models/low_drogon-r1.stl | bash scripts/run-vox-blit.sh 359 70 247 -73 stone

## nyc
#cat models/nyc-no-floor.stl | bash scripts/run-vox-blit.sh 1357 256 679 -256 quartz_block

# serpinski pyramid
#bash scripts/run-gen-synth.sh openscad/structure-synth.mlx eisenscript/pyramid.es | bash scripts/run-vox-blit.sh 279 -1024 152 -1024 sandstone
