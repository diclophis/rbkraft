#!/bin/bash

#bash run-gen-text.sh "mavencraft.net" | bash run-vox-blit.sh 1024 256 48 256 glowstone

#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/octo.es | bash run-vox-blit.sh 600 0 -175 0 air
#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/octo.es | bash run-vox-blit.sh 600 0 -175 0 lava
#bash run-gen-scad.sh openscad/sphere.scad | bash run-vox-blit.sh 64 0 -72 0 air
#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/frames.es | bash run-vox-blit.sh 50 0 -96 0 obsidian

#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/pyramid.es | bash run-vox-blit.sh 128 512 -72 0 sandstone

#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/simple-structures.es | bash run-vox-blit.sh 256 -100 0 -100 sandstone

bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/block-of-buildings.es | bash run-vox-blit.sh 333 300 -32 300 stone

#bash run-gen-scad.sh openscad/sphere.scad | bash run-vox-blit.sh 100 0 -96 0 air
#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/frames.es | bash run-vox-blit.sh 32 0 -96 0 sandstone
#bash run-gen-synth.sh openscad/structure-synth-alt.mlx eisenscript/other-buildings.es | bash run-vox-blit.sh 128 -2500 -32 -2500 sandstone
