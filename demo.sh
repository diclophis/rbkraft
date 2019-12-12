#!/bin/bash

bash run-gen-text.sh "mavencraft.net" | bash run-vox-blit.sh 1200 256 16 256 dirt

#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/octo.es | bash run-vox-blit.sh 600 0 -175 0 air
#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/octo.es | bash run-vox-blit.sh 600 0 -175 0 lava

#bash run-gen-scad.sh openscad/sphere.scad | bash run-vox-blit.sh 256 0 -32 0 iron_bars
#bash run-gen-scad.sh openscad/sphere.scad | bash run-vox-blit.sh 256 0 -32 0 iron_bars

bash run-gen-scad.sh openscad/sphere.scad | bash run-vox-blit.sh 48 0 -16 0 sandstone

bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/frames.es | bash run-vox-blit.sh 400 0 -20 0 sandstone

#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/pyramid.es | bash run-vox-blit.sh 720 512 -32 0 sandstone

#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/simple-structures.es | bash run-vox-blit.sh 256 -100 0 -100 sandstone

#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/block-of-buildings.es | bash run-vox-blit.sh 333 30 -60 30 stone

#bash run-gen-scad.sh openscad/sphere.scad | bash run-vox-blit.sh 100 0 -96 0 air
#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/frames.es | bash run-vox-blit.sh 32 0 -96 0 sandstone
#bash run-gen-synth.sh openscad/structure-synth-alt.mlx eisenscript/other-buildings.es | bash run-vox-blit.sh 128 -2500 -32 -2500 sandstone
