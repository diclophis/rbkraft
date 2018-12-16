#!/bin/bash

set -e
set -x

mkdir -p ~/.local/share

for I in `seq 0 15`
do
  openscad -D shape=${I} -o /home/minecraft/shape-${I}.stl /home/minecraft/map-parts.scad
  /home/minecraft/voxelizer/build/bin/voxelizer 16 4 /home/minecraft/shape-${I}.stl /home/minecraft/shape-${I}.vox
done
