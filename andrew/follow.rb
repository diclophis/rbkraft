require_relative '../world-painter/world_painter.rb'
require 'pp'

painter = WorldPainter.new(20_050, 70, 19_960, async_client: false, debug: true)
print "Player: "
STDOUT.flush
player_name = gets.strip

painter.center = painter.player_position(player_name)

memory = {}
previous_floor_tiles = []
previous_position = nil
while true
  sleep 0.05
  new_pos = painter.player_position(player_name) - painter.center
  ground_position = new_pos + Vector.new(0, -1, 0)
  if ground_position != previous_position
    floor_tiles = []
    (-2).upto(2) do |x|
      (-2).upto(2) do |z|
        floor_tiles << ground_position + Vector.new(x, 0, z)
      end
    end

    floor_tiles.each do |tile|
      memory[tile] ||= painter.test(tile)
    end

    painter.async do
      floor_tiles.each do |tile|
        if memory[tile] == 'air'
          painter.place tile, 'glass'
        end
      end

      (previous_floor_tiles - floor_tiles).each do |tile|
        painter.place tile, 'air' if memory[tile] == 'air'
      end
    end

    previous_floor_tiles = floor_tiles
    previous_position = ground_position
  end
end



