#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'diclophis_world_painter'

srand

oox = 0
ooy = 0
ooz = 0

global_painter = DiclophisWorldPainter.new(oox, ooy, ooz)
puts "connected"
#puts global_painter.execute("setworldspawn 0 70 0")

if true
  global_painter.async do
    (-122..122).each { |ttx|
      (-122..122).each { |tty|
        v = 14
        #global_painter.execute("tp world,#{(ttx * v).to_i},#{(200).to_i},#{(tty * v).to_i}")
        #global_painter.execute("setworldspawn #{ttx.to_i * v} 70 #{tty.to_i * v}")
        #position = Vector.new(ttx, 180, tty) #painter.player_position("faker")
        global_painter.place(ttx * v, 1, tty * v, global_painter.sand_type)
        global_painter.place(ttx * v, 2, tty * v, global_painter.sand_type)
        sleep 0.1
        $stdout.write(".")
      }
    }
  end
  exit
end
