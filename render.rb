#!/usr/bin/env ruby

require 'json'

orig = JSON.parse($stdin.read)
orig["chunkList"] = (-30...30).to_a.product((-30..30).to_a)
puts orig.to_json
