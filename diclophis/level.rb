#!/usr/bin/env ruby

class Level
  attr_accessor :points

  def initialize(level_filename)
    self.points = Array.new
    parse_level_data(load_level_data(level_filename))
  end

  def byte_to_binary(byte)
    binary = ""
    z = 16
    while z > 0 do
      binary += ((byte & z) == z) ? "1" : "0"
      z >>= 1 
    end

    binary
  end

  def load_level_data(level_filename)
    File.open(level_filename).readlines.join("").gsub("\n", "")
  end

  def parse_level_data(level_data)
    current = Array.new(3, 0) 
    i = 0
    l = level_data.length
    dictionary = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = Array.new(l, nil)
    j = 0

    while j<l do
      data[j] = dictionary.index(level_data[j])
      j += 1
    end

    while i<l do
      code = byte_to_binary(data[i])
      i += 1
      if ( code[1] == '1' ) 
        current[0] += data[i] - 32
        i += 1
      end

      if ( code[2] == '1' )
        current[1] += data[i] - 32
        i += 1
      end

      if ( code[3] == '1' )
        current[2] += data[i] - 32
        i += 1
      end

      if ( code[4] == '1' )
        current[3] += data[i] - 32
        i += 1
      end

      if ( code[0] == '1' )
        self.points << current.dup
      end
    end
  end
end

puts Level.new("diclophis/levels/four_corners").inspect
