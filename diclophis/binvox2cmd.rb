#!/usr/bin/env ruby

$: << "."
$: << "diclophis"

require 'strscan'
require 'diclophis_world_painter'

# area filled: 2 x 2 x 2
# integer bounding box: [0,0,0] - [1,1,1]
# counted 8 set voxels out of 8
# Wrote 8 set voxels out of 8, in 2 bytes

V=ARGV[0]
X=ARGV[1].to_i
Y=ARGV[2].to_i
Z=ARGV[3].to_i
T=ARGV[4]

def coordinate_space(vx, vy, vz, dx, dy, dz, tx, ty, tz, sx, sy, sz)
  x_n = (vx.to_f+0.5)/dx.to_f
  y_n = (vy.to_f+0.5)/dy.to_f
  z_n = (vz.to_f+0.5)/dz.to_f
  x = sx.to_f*x_n + tx.to_f
  y = sy.to_f*y_n + ty.to_f
  z = sz.to_f*z_n + tz.to_f

  return x, y, z
end

#int
#Voxels::get_index(int x, int y, int z)
#{
#  int index = x * wxh + z * width + y;  // wxh = width * height = d * d
#  return index;
#
#}  // Voxels::get_index

invox = File.open(V)
scanner = StringScanner.new("")

min_x = max_x = min_y = max_y = min_z = max_z = nil
bit_a = bit_b = bit_c = nil

scanner_state = 0

version = nil

count = 0

gridsize = -1

scale = 0.0

depth = -1
height = -1
width = -1

translate_x = -1
translate_y = -1
translate_z = -1

lx = 0
ly = 0
lz = 0

oox = 0
ooy = 0
ooz = 0

pairs = []

EOL = /#{$/}/

global_painter = DiclophisWorldPainter.new(true, oox, ooy, ooz)
puts "connected"

global_painter.async do
  while r = invox.getbyte
    case scanner_state
      when 0
        scanner << r.chr

        if scanner.check_until EOL
          line = scanner.scan_until(EOL).strip

          case line
            when /#binvox/
              version = line

            when /dim/
              _, depth, height, width = line.split(" ").collect(&:to_i)

            when /translate/
              _, translate_x, translate_y, translate_z = line.split(" ").collect(&:to_f)

            when /scale/
              _, scale = line.split(" ").collect(&:to_i)

            when /data/
              puts [version, depth, height, width, translate_x, translate_y, translate_z, scale].inspect

              scanner_state += 1
              invox.binmode

          end
        end
    else
      pairs << r

      if pairs.length == 2
        draw, draw_distance = *pairs
        pairs.clear

        draw_distance.times { |d|
          block_type = T

          scribble = [(lx + X) - (depth / 2), (ly + Y) - (height / 2), (lz + Z) - (width / 2), block_type]

          if draw == 1
            global_painter.place(*scribble)
          end

          count += 1

          ly += 1
          if (ly % height) == 0
            ly = 0
            lz += 1
            if (lz % width) == 0
              lz = 0
              lx += 1
              if (lx % depth) == 0
                lx = 0
              end
            end
          end
        }
      end
    end
  end
end

puts [:total_voxels_blitted, global_painter.client.command_count].inspect
