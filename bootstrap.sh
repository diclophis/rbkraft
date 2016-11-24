#!/bin/sh

MINECRAFT_ROOT=/home/minecraft

set -e
set -x

cd $MINECRAFT_ROOT/libccd && $MINECRAFT_ROOT/libccd/bootstrap && mkdir -p $MINECRAFT_ROOT/libccd/build && cd $MINECRAFT_ROOT/libccd/build && $MINECRAFT_ROOT/libccd/configure --prefix=/usr && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr $MINECRAFT_ROOT/libccd && make -j 8 && sudo make install
cd $MINECRAFT_ROOT/fcl && mkdir -p $MINECRAFT_ROOT/fcl/build && cd $MINECRAFT_ROOT/fcl/build && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr $MINECRAFT_ROOT/fcl && make -j 8 && sudo make install
cd $MINECRAFT_ROOT/voxelizer && mkdir -p $MINECRAFT_ROOT/voxelizer/build && cd $MINECRAFT_ROOT/voxelizer/build && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr $MINECRAFT_ROOT/voxelizer && make -j 8
