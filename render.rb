#!/usr/bin/env ruby

require 'json'

WWW = 5

orig = JSON.parse($stdin.read)
puts orig.inspect
exit 1
orig["chunkList"] = (-WWW...WWW).to_a.product((-WWW..WWW).to_a).collect { |a| [a[0] + 2, a[1] + 2] }
puts orig.to_json
