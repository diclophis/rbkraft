#!/bin/sh

set -e
set -x

MINECRAFT_ROOT=/home/minecraft
OUT=$MINECRAFT_ROOT/tmp/text-output.stl
SIZE=960

#rm -Rf $OUT

#openscad -D 'msg=" - - - - - - - - - - ありがとう - - - - Welcome, Matz - - - - - 1 - - - - - -"' --autocenter -o $OUT $MINECRAFT_ROOT/voxelize-stl-xinetd/text_sphere.scad

#openscad -D 'msg="- - - - あ - - - -"' --autocenter -o $OUT $MINECRAFT_ROOT/voxelize-stl-xinetd/text_sphere.scad

#openscad -D 'msg="ありがとう まつもとゆきひろ"' --autocenter -o $OUT $MINECRAFT_ROOT/voxelize-stl-xinetd/text_sphere.scad

#openscad -D 'msg="あ"' --autocenter -o $OUT $MINECRAFT_ROOT/voxelize-stl-xinetd/text_sphere.scad

#openscad -D 'other_msg=" 💎"' -D 'msg="ろ"' --autocenter -o $OUT $MINECRAFT_ROOT/voxelize-stl-xinetd/text_sphere.scad

#openscad -D 'msg="あ"' --autocenter -o $OUT $MINECRAFT_ROOT/voxelize-stl-xinetd/text_sphere.scad

/home/minecraft/voxelizer/build/bin/voxelizer $SIZE 8 $OUT $OUT.vox

export MAVENCRAFT_SERVER=localhost
export MAVENCRAFT_PORT=25566

#/home/minecraft/voxelizer/build/test/testVox $OUT.vox | ruby /home/minecraft/voxelize-stl-xinetd/main.rb $SIZE -200 -160 -300

#/home/minecraft/voxelizer/build/test/testVox $OUT.vox | ruby /home/minecraft/voxelize-stl-xinetd/main.rb $SIZE -100 -525 -133

/home/minecraft/voxelizer/build/test/testVox $OUT.vox | ruby /home/minecraft/voxelize-stl-xinetd/main.rb $SIZE -175 -525 -433 redstone_block
