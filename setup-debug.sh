#!/bin/bash

set -e
set -x

mkdir -p ~/.local/share

for I in `seq 0 17`
do
  openscad -D shape=${I} -o /home/minecraft/shape-${I}.stl /home/minecraft/map-parts.scad
  /home/minecraft/voxelizer/build/bin/voxelizer 32 8 /home/minecraft/shape-${I}.stl /home/minecraft/shape-${I}.vox
done
