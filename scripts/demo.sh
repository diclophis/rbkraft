#!/bin/bash

#bash scripts/console-runner.sh ruby diclophis/draw_a_square.rb
#bash scripts/console-runner.sh ruby diclophis/explore-world.rb 16 64 tnt

######### glass sphere at 0,0
#cat openscad/sphere.scad \
#  | bash scripts/console-runner.sh ruby diclophis/scad.rb \
#  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
#  37 0 100 0 sandstone

########## makes the giant text logo
#echo "★ hello world ♥ " \
#  | bash scripts/console-runner.sh ruby diclophis/text.rb \
#  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
#  177 -32 237 -32 stone

##### dragon
#cat models/low_drogon-r1.stl \
#  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
#  128 -64 64 64 stone

cat ~/Downloads/castle-102.stl \
  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
  349 0 175 0 stone

##### cathedral
#cat models/cathedral-100.stl \
#  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
#  197 -128 100 -64 stone

#### nyc
#cat models/nyc-no-floor.stl \
#  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
#  512 0 260 0 quartz_block

####### serpinski pyramid
#cat eisenscript/pyramid.es \
#  | bash scripts/console-runner.sh ruby diclophis/structure_synth_inline.rb openscad/structure-synth.mlx \
#  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
#  128 0 64 0 stone

######## base lofts
#cat eisenscript/loft-like.es \
#  | bash scripts/console-runner.sh ruby diclophis/structure_synth_inline.rb openscad/structure-synth.mlx \
#  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
#  100 32 55 -32 stone

###### simple buildings
#cat eisenscript/block-of-buildings.es \
#  | bash scripts/console-runner.sh ruby diclophis/structure_synth_inline.rb openscad/structure-synth.mlx \
#  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
#  90 -32 160 -32 stone

##### bridge
#cat eisenscript/simple-structures.es \
#  | bash scripts/console-runner.sh ruby diclophis/structure_synth_inline.rb openscad/structure-synth.mlx \
#  | bash scripts/console-runner.sh ruby diclophis/stl_stdin_blit_vox.rb \
#  200 -32 159 64 stone
