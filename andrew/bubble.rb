require_relative '../world-painter/world_painter.rb'
require 'pp'

painter = WorldPainter.new(20_050, 70, 19_960, async_client: false, debug: false)
print "Player: "
STDOUT.flush
player_name = gets.strip

painter.center = painter.player_position(player_name)

memory = {}
previous_area_tiles = []
previous_wall_tiles = []
previous_position = nil
while true
  sleep 0.05
  new_pos = painter.player_position(player_name) - painter.center
  if new_pos != previous_position
    area_tiles = []
    wall_tiles = []

    size = 4

    (-size).upto(size) do |x|
      (-size).upto(size) do |y|
        (-size).upto(size) do |z|
          if x == size || x == -size || y == size || y == -size || z == size || z == -size
            wall_tiles << new_pos + Vector.new(x, y, z)
          else
            area_tiles << new_pos + Vector.new(x, y, z)
          end
        end
      end
    end

    painter.bulk_test((area_tiles + wall_tiles) - memory.keys).each do |tile, type|
      memory[tile] = type
    end

    painter.async do
      (area_tiles - previous_area_tiles).each do |tile|
        painter.place tile, 'air' unless memory[tile] == 'air' && !previous_wall_tiles.include?(tile)
      end

      (wall_tiles - previous_wall_tiles).each do |tile|
        painter.place tile, 'glass'
      end

      # Glowstone
      if previous_position
        old_glow_stone = Vector.new(previous_position.x + 2, previous_position.y + 2, previous_position.z + 2)
        if area_tiles.include?(old_glow_stone)
          painter.place(old_glow_stone, 'air')
        else
          painter.place(old_glow_stone, WorldPainter::TYPE_MAPPINGS[memory[old_glow_stone]])
        end
      end
      painter.place(Vector.new(new_pos.x + 2, new_pos.y + 2, new_pos.z + 2), 'glowstone')

      ((previous_area_tiles + previous_wall_tiles) - (area_tiles + wall_tiles)).each do |tile|
        if WorldPainter::TYPE_MAPPINGS[memory[tile]]
          replacement = WorldPainter::TYPE_MAPPINGS[memory[tile]]
          if replacement == 'glass'
            painter.place tile, 'air'
          else
            painter.place tile, replacement unless memory[tile] == 'air' && !previous_wall_tiles.include?(tile)
          end
        else
          puts "UNKNOWN: #{memory[tile]}"
        end
        # memory.delete(tile)
      end
    end

    previous_area_tiles = area_tiles
    previous_wall_tiles = wall_tiles
    previous_position = new_pos
  end
end