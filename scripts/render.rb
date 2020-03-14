#!/usr/bin/env ruby

require 'json'

TIME=ARGV[0].to_i
SPP=ARGV[1].to_i
WIDTH=ARGV[2].to_i
HEIGHT=ARGV[3].to_i

WWW=175

orig = JSON.parse($stdin.read)

x = orig["camera"]["position"]["x"].to_i + (TIME / 10) #/ 100.to_f).to_i
y = orig["camera"]["position"]["z"].to_i
#fov = orig["camera"]["fov"] - (TIME.to_f * 3.5)
pitch = orig["camera"]["orientation"]["pitch"] + (TIME.to_f * 0.01) 

#if fov < 35.0
#  fov = 35.0
#end

ox = 32 * 3
oy = -32 * 3

#regionX = (chunkX / 32.0).floor.to_i
#regionZ = (chunkZ / 32.0).floor.to_i

orig["chunkList"] = (-WWW...WWW).to_a.product((-WWW..WWW).to_a).collect { |a| [(a[0] + x + ox) / 16, (a[1] + y + oy) / 16] }.uniq

orig["camera"]["position"]["x"] = x.to_f
orig["sppTarget"] = SPP
#orig["camera"]["fov"] = fov
orig["camera"]["orientation"]["pitch"] = pitch
orig["width"] = WIDTH
orig["height"] = HEIGHT

puts orig.to_json
