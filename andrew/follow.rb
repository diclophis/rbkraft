require_relative '../world-painter/world_painter.rb'
require 'pp'

painter = WorldPainter.new(0, 70, 0, async_client: false, debug: true)
print "Player: "
STDOUT.flush
player_name = gets.strip

painter.center = painter.player_position(player_name)

memory = {}
previous_floor_tiles = []
previous_position = nil
while true
  sleep 1.05
  new_pos = painter.player_position(player_name) - painter.center
  puts new_pos.inspect
  ground_position = new_pos + Vector.new(0, -1, 0)
  if ground_position != previous_position
    floor_tiles = []
    (-3).upto(3) do |x|
      (-3).upto(3) do |z|
        floor_tiles << ground_position + Vector.new(x, 0, z)
      end
    end

    painter.bulk_test(floor_tiles - memory.keys).each do |tile, type|
      memory[tile] = type
    end

    painter.async do
      (floor_tiles - previous_floor_tiles).each do |tile|
        if memory[tile] == 'air' || memory[tile] == 'glass'
          painter.place tile, 'glass'
        end
      end

      (previous_floor_tiles - floor_tiles).each do |tile|
        painter.place tile, 'air' if memory[tile] == 'air' || memory[tile] == 'glass'
      end
    end

    previous_floor_tiles = floor_tiles
    previous_position = ground_position
  end
end
