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
    (-32..32).each { |ttx|
      (-32..32).each { |tty|
        v = 18 
        #global_painter.execute("tp world,#{(ttx * v).to_i},#{(200).to_i},#{(tty * v).to_i}")
        #global_painter.execute("setworldspawn #{ttx.to_i * v} 70 #{tty.to_i * v}")
        #position = Vector.new(ttx, 180, tty) #painter.player_position("faker")
        #h = ((1.0 + Math.sin((ttx.to_f).abs * (tty.to_f).abs)) * 64.0).to_i
        #global_painter.place(ttx * v + 0, h + 16, tty * v + 0, global_painter.water_type)
        #puts h.inspect
        #h.times { |hh|
        #  3.times { |ii|
        #    global_painter.place(ttx * v + ii, hh, tty * v + ii, global_painter.air_type)
        #  }
        ##  global_painter.place(ttx * v, hh, tty * v, global_painter.water_type)
        #}
        global_painter.place(ttx * v, 1, tty * v, global_painter.bedrock_type)
        $stdout.write(".")
      }
    }
  end
  exit
end
