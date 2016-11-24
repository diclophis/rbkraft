#!/bin/sh

set -e
set -x

MINECRAFT_ROOT=/home/minecraft
OUT=$MINECRAFT_ROOT/tmp/text-output.stl

openscad -D 'msg="⚛ ⚚ ☃ ☂ ♒"' --autocenter -o $OUT $MINECRAFT_ROOT/voxelize-stl-xinetd/text_sphere.scad

#cat $MINECRAFT_ROOT/tmp/text-output.stl | gzip | nc localhost 33333

SIZE=$(cat /var/tmp/size)
/home/minecraft/voxelizer/build/bin/voxelizer $SIZE 8 $OUT $OUT.vox

export MAVENCRAFT_SERVER=localhost
export MAVENCRAFT_PORT=25566

/home/minecraft/voxelizer/build/test/testVox $OUT.vox | ruby /home/minecraft/voxelize-stl-xinetd/main.rb 0 0
