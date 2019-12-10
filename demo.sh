#!/bin/bash

#TODO: where does hello.stl generate from?
#bash run-gen-text.sh "Hello World" | bash run-vox-blit.sh 1024 2000 64 2000 sandstone

#http://mavencraft.net:31580/#mavencraft_day/0/5/990/794/64
#ruby diclophis/structure_synth_inline.rb openscad/structure-synth.mlx eisenscript/simple-structures.es 2> /dev/null | bash run-vox-blit.sh 256 1000 0 700

#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/simple-structures.es | bash run-vox-blit.sh 256 -1000 0 -1000 sandstone
#bash run-gen-synth.sh openscad/structure-synth.mlx eisenscript/pyramid.es | bash run-vox-blit.sh 256 100 50 100 sandstone
bash run-gen-synth.sh openscad/structure-synth-alt.mlx eisenscript/other-buildings.es | bash run-vox-blit.sh 128 -2500 -32 -2500 sandstone

#| bash run-vox-blit.sh 64 500 128 500 sandstone

#ruby diclophis/text.rb "$1"
#> /var/tmp/txt.stl

#cat /var/tmp/long-b.stl | bash run-vox-blit.sh 480 1000 -54 -8600
#http://structuresynth.sourceforge.net/reference.php
#http://www.timestretch.com/article/structure_synth_tutorial

#buildings
#ruby diclophis/structure_synth_inline.rb openscad/structure-synth-alt.mlx eisenscript/other-buildings.es > /var/tmp/other-c.stl
#cat /var/tmp/other-c.stl | bash run-vox-blit.sh 128 100 -64 0
#https://github.com/ssrb/mega-structure
