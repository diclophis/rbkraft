#!/bin/sh

set -e
set -x

MINECRAFT_ROOT=/home/minecraft
OUT=$MINECRAFT_ROOT/tmp/text-output.stl
SIZE=512

openscad -D 'msg="Hello World, Matz"' --autocenter -o $OUT $MINECRAFT_ROOT/voxelize-stl-xinetd/text_sphere.scad

/home/minecraft/voxelizer/build/bin/voxelizer $SIZE 8 $OUT $OUT.vox

export MAVENCRAFT_SERVER=localhost
export MAVENCRAFT_PORT=25566

/home/minecraft/voxelizer/build/test/testVox $OUT.vox | ruby /home/minecraft/voxelize-stl-xinetd/main.rb $SIZE 128 -48 128
