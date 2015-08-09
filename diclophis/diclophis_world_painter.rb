#!/usr/bin/env ruby

require 'world-painter/world_painter'

class DiclophisWorldPainter < WorldPainter
  attr_accessor :type, :air_type, :debug_type,
  :alt_type, :corner_type, :slab, :glass_type, :glow_type,
  :sand_type, :sandstone_type, :water_type, :tnt_type, :lava_type,
  :iron_bars_type, :bedrock_type, :quartz_type

  def initialize(*args)
    super(*args)

    @air_type = "air"
    @type = air_type
    @debug_type = air_type
    @alt_type = air_type
    @corner_type = air_type 
    @slab = air_type 
    @glass_type = air_type
    @glow_type = air_type
    @sand_type = air_type
    @sandstone_type = air_type
    @water_type = air_type
    @tnt_type = air_type
    @lava_type = air_type
    @iron_bars_type = air_type
    @bedrock_type = air_type
    @quartz_type = air_type

    if ARGV[0] == "draw"
      @type = "stone"
      @glow_type = "glowstone"
      @slab = "stone_slab"
      @debug_type = "glowstone"
      @alt_type = "stonebrick"
      @corner_type = "log"
      @glass_type = "glass"
      @sand_type = "sand"
      @sandstone_type = "sandstone"
      @water_type = "water"
      @tnt_type = "tnt"
      @lava_type = "lava"
      @iron_bars_type = "iron_bars"
      @bedrock_type = "bedrock"
      @quartz_type = "quartz_block"
    end
  end
end
