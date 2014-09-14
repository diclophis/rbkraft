#!/usr/bin/env ruby

require_relative '../world-painter/world_painter.rb'

def prompt(msg)
  print msg + " "
  STDOUT.flush
  gets.strip
end

def load_painter
  painter = WorldPainter.new(20_050, 70, 19_960, async_client: false, debug: true)
  player_name = prompt("Player:")
  player_name = 'tectonic_earth' if player_name == ''
  if player_name == 'last'
    painter.center = Vector.new(*File.read('last_center.dat').split("\n").last.split(' ').map(&:to_i))
  else
    painter.center = painter.player_position(player_name)
  end

  File.open('last_center.dat', 'a') do |file|
    file.puts painter.center.to_a.join(' ')
  end

  painter
end
