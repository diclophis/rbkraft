require_relative '../world-painter/world_painter.rb'
require 'pp'

painter = WorldPainter.new(20_050, 70, 19_960, async_client: false, debug: false)
print "Player: "
STDOUT.flush
player_name = gets.strip

painter.center = painter.player_position(player_name)

memory = {}
previous_area_tiles = []
previous_position = nil
while true
  sleep 0.05
  new_pos = painter.player_position(player_name) - painter.center
  if new_pos != previous_position
    area_tiles = []
    (-2).upto(2) do |x|
      (-2).upto(2) do |y|
        (-2).upto(2) do |z|
          area_tiles << new_pos + Vector.new(x, y, z)
        end
      end
    end

    painter.bulk_test(area_tiles - memory.keys).each do |tile, type|
      memory[tile] = type
    end

    painter.async do
      (area_tiles - previous_area_tiles).each do |tile|
        painter.place tile, 'air' unless memory[tile] == 'air'
      end

      if previous_position
        old_glow_stone = Vector.new(previous_position.x + 2, previous_position.y + 2, previous_position.z + 2)
        if area_tiles.include?(old_glow_stone)
          painter.place(old_glow_stone, 'air')
        else
          painter.place(old_glow_stone, WorldPainter::TYPE_MAPPINGS[memory[old_glow_stone]])
        end
      end
      painter.place(Vector.new(new_pos.x + 2, new_pos.y + 2, new_pos.z + 2), 'glowstone')

      (previous_area_tiles - area_tiles).each do |tile|
        if WorldPainter::TYPE_MAPPINGS[memory[tile]]
          painter.place tile, WorldPainter::TYPE_MAPPINGS[memory[tile]] unless memory[tile] == 'air'
        else
          puts "UNKNOWN: #{memory[tile]}"
        end
        memory.delete(tile)
      end
    end

    previous_area_tiles = area_tiles
    previous_position = new_pos
  end
end