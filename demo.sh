#!/bin/bash

#TODO: where does hello.stl generate from?
ruby diclophis/text.rb "hello world" > /var/tmp/txt.stl
cat /var/tmp/txt.stl | bash run-vox-blit.sh 1024 20000 128 20000

#http://mavencraft.net:31580/#mavencraft_day/0/5/990/794/64
ruby diclophis/structure_synth_inline.rb openscad/structure-synth.mlx eisenscript/simple-structures.es 2> /dev/null | bash run-vox-blit.sh 256 1000 0 700

#cat /var/tmp/long-b.stl | bash run-vox-blit.sh 480 1000 -54 -8600
#http://structuresynth.sourceforge.net/reference.php
#http://www.timestretch.com/article/structure_synth_tutorial

#buildings
#ruby diclophis/structure_synth_inline.rb openscad/structure-synth-alt.mlx eisenscript/other-buildings.es > /var/tmp/other-c.stl
#cat /var/tmp/other-c.stl | bash run-vox-blit.sh 128 100 -64 0
#https://github.com/ssrb/mega-structure
