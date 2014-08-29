#!/usr/bin/env ruby

require_relative '../world-painter/world_painter.rb'

painter = WorldPainter.new(20_050, 70, 19_960, async_client: false, debug: true)
p painter.player_position('tectonic_earth')

