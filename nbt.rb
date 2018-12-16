#!/usr/bin/env ruby

require 'nbt_utils'
  
@file = NBTUtils::File.new
@tag = @file.read(ARGV[0])

puts @tag.find_tag("Pos").payload.to_ary.collect { |t| t.payload.value }
