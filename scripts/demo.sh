#!/bin/bash

#### glass sphere at 0,0
cat openscad/sphere.scad \
  | bash scripts/console-runner.sh ruby diclophis/scad.rb \
  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
  32 0 128 0 glass
cat openscad/sphere.scad \
  | bash scripts/console-runner.sh ruby diclophis/scad.rb \
  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
  8 0 128 0 sandstone

### makes the giant mavencraft logo
echo "★ mavencraft.net ♥" \
  | bash scripts/console-runner.sh ruby diclophis/text.rb \
  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
  500 0 256 0 obsidian

### dragon
#cat models/low_drogon-r1.stl \
#  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
#  359 70 247 -73 stone

### nyc
#cat models/nyc-no-floor.stl \
#  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
#  1357 256 679 -256 quartz_block

# serpinski pyramid
#bash scripts/run-gen-synth.sh openscad/structure-synth.mlx eisenscript/pyramid.es | bash scripts/run-vox-blit.sh 279 -1024 152 -1024 sandstone
