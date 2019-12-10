#!/bin/bash

#bash run-gen-text.sh "Hello World" | bash run-vox-blit.sh 1024 2000 64 2000 sandstone
#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/simple-structures.es | bash run-vox-blit.sh 256 -1000 0 -1000 sandstone
bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/frames.es | bash run-vox-blit.sh 32 0 -96 0 sandstone
#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/pyramid.es | bash run-vox-blit.sh 72 600 -72 600 sandstone
#bash run-gen-synth.sh openscad/structure-synth-alt.mlx eisenscript/other-buildings.es | bash run-vox-blit.sh 128 -2500 -32 -2500 sandstone
#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/octo.es | bash run-vox-blit.sh 600 0 -175 0 air
#bash run-gen-scad.sh openscad/sphere.scad | bash run-vox-blit.sh 100 0 -96 0 air
