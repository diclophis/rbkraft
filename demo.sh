#!/bin/bash

#bash run-gen-text.sh "mavencraft.net" | bash run-vox-blit.sh 1200 256 16 256 dirt
#bash run-gen-text.sh "mavencraft.net" | bash run-vox-blit.sh 1024 0 600 0 dirt

#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/octo.es | bash run-vox-blit.sh 600 0 -175 0 air

#bash run-gen-scad.sh openscad/sphere.scad | bash run-vox-blit.sh 256 0 -32 0 iron_bars
#bash run-gen-scad.sh openscad/sphere.scad | bash run-vox-blit.sh 256 0 -32 0 iron_bars

#bash run-gen-scad.sh openscad/sphere.scad | bash run-vox-blit.sh 48 0 -16 0 sandstone
#
#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/frames.es | bash run-vox-blit.sh 400 0 -20 0 sandstone

#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/pyramid.es | bash run-vox-blit.sh 256 1024 256 1024 sandstone

#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/simple-structures.es | bash run-vox-blit.sh 256 -100 0 -100 sandstone

#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/block-of-buildings.es | bash run-vox-blit.sh 256 0 256 0 stone

#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/frames.es | bash run-vox-blit.sh 256 0 128 0 stone

#bash run-gen-synth.sh openscad/structure-synth-alt.mlx eisenscript/other-buildings.es | bash run-vox-blit.sh 128 0 72 0 sandstone
#bash run-gen-synth.sh openscad/structure-synth-alt.mlx eisenscript/other-buildings.es | bash run-vox-blit.sh 128 128 72 128 sandstone
#bash run-gen-synth.sh openscad/structure-synth-alt.mlx eisenscript/other-buildings.es | bash run-vox-blit.sh 128 -128 72 -128 sandstone

#cat models/reims_thickened_shrunk.stl | bash run-vox-blit.sh 367 256 185 256 stone
bash run-gen-scad.sh openscad/sphere.scad | bash run-vox-blit.sh 32 0 64 0 glass
bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/octo.es | bash run-vox-blit.sh 333 -256 200 256 sandstone
cat models/nyc-no-floor.stl | bash run-vox-blit.sh 1357 256 679 -256 quartz_block
bash run-gen-text.sh "mavencraft.net" | bash run-vox-blit.sh 777 0 600 0 obsidian
bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/pyramid.es | bash run-vox-blit.sh 279 512 152 512 sandstone
