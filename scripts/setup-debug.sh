#!/bin/bash

set -e
set -x

mkdir -p ~/.local/share

for I in `seq 0 20`
do
  openscad -D shape=${I} -o /home/app/shape-${I}.stl /home/app/openscad/map-parts.scad
  /home/app/voxelizer/build/bin/voxelizer 32 8 /home/app/shape-${I}.stl /home/app/shape-${I}.vox
done
