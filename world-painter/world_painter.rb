#!/usr/bin/env ruby

require_relative '../minecraft-wrapper/client.rb'

# Minecraft block types: http://minecraft-ids.grahamedgecombe.com/
# Id of 0 is delete.
# Data values: http://minecraft.gamepedia.com/Data_values#Leaves

class Vector
  attr_accessor :x, :y, :z

  def initialize(*args)
    if args.first.is_a?(Array)
      @x, @y, @z = args.first
    elsif args.first.is_a?(Vector)
      @x, @y, @z = args.first.to_a
    else
      @x, @y, @z = args
    end

    @x, @y, @z = @x.to_i, @y.to_i, @z.to_i
  end

  def -(v)
    Vector.new(x - v.x, y - v.y, z - v.z)
  end

  def +(v)
    Vector.new(x + v.x, y + v.y, z + v.z)
  end

  def /(c)
    Vector.new(x/c, y/c, z/c)
  end

  def *(c)
    Vector.new(x*c, y*c, z*c)
  end

  def length
    Math.sqrt(x*x + y*y + z*z)
  end
  alias_method :magnitude, :length

  def normalized
    self / length
  end

  def abs
    Vector.new(x.abs, y.abs, z.abs)
  end

  def max
    to_a.max
  end

  def round
    Vector.new(x.round, y.round, z.round)
  end

  def to_a
    [x, y, z]
  end

  def [](index)
    to_a[index]
  end

  def ==(c)
    c && c.is_a?(Vector) && x == c.x && y == c.y && z == c.z
  end

  # For hash behavior to work the way we want, we need to override #hash and #eql?.

  def hash
    to_a.hash
  end

  alias eql? ==
end

class WorldPainter
  attr_accessor :center, :client

  TYPE_MAPPINGS = {
    'wood' => 'log',
    'stone' => 'stone',
    'tile.dirt.name' => 'dirt',
    'grass block' => 'grass',
    'clay' => 'clay',
    'tile.doubleplant.name' => 'double_plant',
    'tile.flower2.name' => 'red_flower',
    'tile.flower1.name' => 'yellow_flower',
    'grass' => 'tallgrass',
    'obsidian' => 'obsidian',
    'bedrock' => 'bedrock',
    'glass' => 'glass',
    'air' => 'air',
    'tile.sand.name' => 'sand',
    'wooden planks' => 'planks',
    'leaves' => 'leaves',
    'water' => 'water',
    'torch' => 'torch',
    'sandstone' => 'sandstone',
    'coal' => 'coal_ore',
    'diamond ore' => 'diamond_ore',
    'coal ore' => 'coal_ore',
    'glowstone' => 'glowstone',
    'redstone ore' => 'redstone_ore',
    'lapis lazuli ore' => 'lapis_ore',
    'gold ore' => 'gold_ore',
    'lava' => 'lava',
    'gravel' => 'gravel',
    'mushroom' => 'brown_mushroom',
    'iron ore' => 'iron_ore',
    'farmland' => 'farmland',
    'oak wood stairs' => 'oak_stairs',
    'cobblestone' => 'cobblestone',
    'wooden planks' => 'planks',
    'crops' => 'wheat',
    'crafting table' => 'crafting_table',
    'fence' => 'fence',
    'wooden door' => 'wooden_door',
    'chest' => 'chest',
    'furnace' => 'furnace',
    'fence gate' => 'fence_gate',
    'diamond ore' => 'diamond_ore'
  }

  GROUND_MAPPINGS = [
    'stone',
    'tile.dirt.name',
    'grass block',
    'clay',
    'obsidian',
    'bedrock',
    'tile.sand.name',
    'water',
    'sandstone',
    'coal',
    'coal ore',
    'glowstone',
    'redstone ore',
    'lapis lazuli ore',
    'gold ore',
    'lava',
    'gravel',
    'iron ore',
    'farmland',
    'diamond ore'
  ]

  def initialize(center_x, center_y, center_z, options = {})
    @center = Vector.new(center_x, center_y, center_z)

    #if @center.magnitude < 10_000
    #  puts "Too close to spawn!"
    #  exit 1
    #end

    @dry_run = options[:dry_run]
    @debug = options[:debug]
    @async = options[:async_client] || true
    @client = MinecraftClient.new(@async)
    #@client.execute_command("spawn")
  end

  def async
    original_async = @async
    set_async true
    yield
    flush_async
    set_async original_async
  end

  def set_async(new_value)
    @async = new_value
    client.async = new_value
  end

  def flush_async
    client.flush_async if @async
  end

  def dry_run?
    @dry_run
  end

  def debug?
    @debug
  end

  def teleport(player, x, y, z)
    cmd = "/tp #{player} #{x.to_i} #{y.to_i} #{z.to_i}"
    execute(cmd)
  end

  # x, y, z, thing = 'dirt', data = 0, mode = 'replace', data_tag = nil
  def place(*args)
    if args.first.is_a?(Vector)
      x, y, z = args.shift.to_a
      thing, data, mode, data_tag = args
    else
      x, y, z, thing, data, mode, data_tag = args
    end
    thing = thing.is_a?(String) ? "#{thing}" : thing
    set_block_command = "bpe #{thing} world,#{(@center.x + x).to_i},#{(@center.y + y).to_i},#{(@center.z + z).to_i}"
    execute set_block_command
  end

  def summon(x, y, z, thing = 'air', data_tag = '')
    summon_command = "summon #{thing} #{(@center.x + x).to_i} #{(@center.y + y).to_i} #{(@center.z + z).to_i} #{data_tag}"
    execute summon_command
  end

  def test(x, y = nil, z = nil)
    x, y, z = x.to_a if x.is_a?(Vector)
    result = execute("testforblock #{(@center.x + x).to_i} #{(@center.y + y).to_i} #{(@center.z + z).to_i} 0", /The block at|Successfully found the block/)
    if result =~ /Successfully found the block/
      'air'
    else
      result[/\d+ is (.*?) \(/, 1].downcase
    end
  end

  # [00:49:57 INFO]: The block at 19563,70,20394 is Grass Block (expected: tile.air.name).
  # [00:49:55 INFO]: Successfully found the block at 19558,70,20391.
  TEST_REGEX = /Successfully found the block at ([\d-]+),([\d-]+),([\d-]+)\.|The block at ([\d-]+),([\d-]+),([\d-]+) is (.*?) \(/
  def bulk_test(vectors)
    vectors.each do |vector|
      client.puts("testforblock #{@center.x + vector.x} #{@center.y + vector.y} #{@center.z + vector.z} 0")
    end

    search = vectors.inject({}) { |m, v| m[v.to_a.join(',')] = v; m } # turn vectors into { "1,2,3" => Vector, "2,3,4" => Vector, ... }
    output = {}
    last_server_data = ''

    while true
      server_data = last_server_data + client.read_nonblock
      puts server_data if debug?
      server_data.scan(TEST_REGEX).each do |match|
        if match[0]
          x,y,z = match
          type = 'air'
        else
          _,_,_,x,y,z,type = match
        end

        x = x.to_i - @center.x
        y = y.to_i - @center.y
        z = z.to_i - @center.z

        search_result = search.delete([x,y,z].join(','))
        output[search_result] = type.downcase if search_result
      end

      break if search.empty?

      last_server_data = server_data.split(TEST_REGEX).last || ''

      sleep 0.05
    end

    output
  end

  def without_debug
    old_debug = @debug
    @debug = false
    yield
    @debug = old_debug
  end

  def execute(cmd, pattern = nil)
    #sleep 0.0105
    if dry_run?
      puts cmd
    else
      puts cmd if debug?
      output = @client.execute_command("vdc faker " + cmd, pattern)
      puts output if debug?
      output
    end
  end

  def platform(center_x = 0, center_y = 0, center_z = 0, width = 10, id = 20, data = 0, options = {})
    width.times do |x|
      width.times do |z|
        options[:before_each].call(center_x - width/2 + x, center_y, center_z - width/2 + z) if options[:before_each]
        place center_x - width/2 + x, center_y, center_z - width/2 + z, id, data
        options[:after_each].call(center_x - width/2 + x, center_y, center_z - width/2 + z) if options[:after_each]
      end
    end
  end

  def ground(x, z, options = {})
    tests = []
    water_level = 60 - center.y
    water_level.upto(water_level + 60) do |y|
      tests << Vector.new(x, y, z)
    end

    ground_matcher = /#{GROUND_MAPPINGS.map { |tile| Regexp::escape tile }.join('|')}/i
    highest = Vector.new(0, water_level - 30, 0)
    highest_type = ''

    bulk_test(tests).each do |tile, type|
      if type =~ ground_matcher
        if tile.y > highest.y
          highest = tile
          highest_type = type
        end
      end
    end

    [highest.y, highest_type]
  end

  # Bresenham’s line drawing algorithm
  # http://www.cb.uu.se/~cris/blog/index.php/archives/400
  def line(p1, p2, options = {})
    p = p1
    d = p2-p1
    n = d.abs.max
    s = d/n.to_f
    n.times do
      p = p+s
      (options[:xwidth] || options[:width] || 1).times do |xw|
        (options[:zwidth] || 1).times do |zw|
          (options[:ywidth] || 1).times do |yw|
            id = evaluate(options[:id])
            data = evaluate(options[:data], 0)
            options[:before_each].call(p.x+xw, p.y+yw, p.z+zw) if options[:before_each]
            puts place p.x+xw, p.y+yw, p.z+zw, id, data
            options[:after_each].call(p.x+xw, p.y+yw, p.z+zw) if options[:after_each]
          end
        end
      end
    end
  end

  def evaluate(something, default = 'air')
    if something.is_a?(Proc)
      something.call || default
    else
      something || default
    end
  end

  def xy_from_angle_radius(angle, radius)
    [Math.cos(angle) * radius, Math.sin(angle) * radius]
  end

  def player_position(player_name)
    position = []
    execute("getpos #{player_name}")
    while line = client.gets
      [:x, :y, :z].each do |c|
        position << (line.split(" ")[6].gsub(",", "")).to_f if line.include?(c.to_s.upcase + ": ")
        #puts line.inspect if line.include?(c.to_s.upcase + ": ")
        #[09:03:57 INFO]: [diclophis] 'diclophis gettingMessage= Current World: world'
        #[09:03:57 INFO]: [diclophis] 'diclophis gettingMessage= X: 0 (+East <-> -West)'
        #[09:03:57 INFO]: [diclophis] 'diclophis gettingMessage= Y: 0 (+Up <-> -Down)'
        #[09:03:57 INFO]: [diclophis] 'diclophis gettingMessage= Z: 704 (+South <-> -North)'
        #[09:03:57 INFO]: [diclophis] 'diclophis gettingMessage= Yaw: 180 (Rotation)'
        #[09:03:57 INFO]: [diclophis] 'diclophis gettingMessage= Pitch: 0 (Head angle)'
        #[09:03:57 INFO]: [diclophis] 'diclophis gettingMessage= Distance: 0'
        #[09:04:08 INFO]: [diclophis] 'diclophis gettingMessage= [Server] charted'
      end
      break if line.include?("Pitch")
    end

    Vector.new(position)
  end
end
