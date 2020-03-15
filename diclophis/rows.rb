#!/usr/bin/env ruby

10.times { |i|
  10.times { |j|
    system("xvfb-run -a -s '-screen 0 800x600x24' ruby diclophis/structure_synth_inline.rb openscad/structure-synth.mlx eisenscript/block-of-buildings.es | xvfb-run -a -s '-screen 0 800x600x24' ruby /home/app/diclophis/stl_stdin_blit_vox.rb 33 #{-300 - (44 * i)} #{60 + (rand * 32.0).to_i} #{44 * j} air")
    system("xvfb-run -a -s '-screen 0 800x600x24' ruby diclophis/structure_synth_inline.rb openscad/structure-synth.mlx eisenscript/loft-like.es | xvfb-run -a -s '-screen 0 800x600x24' ruby /home/app/diclophis/stl_stdin_blit_vox.rb 64 #{-300 - (64 * i)} #{92 + (rand * 44.0).to_i} #{64 * j} stone")
  }
}
