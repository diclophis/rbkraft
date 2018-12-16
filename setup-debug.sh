#!/bin/bash

set -e
set -x

cd /home/minecraft/fcl

mkdir build
cd build
cmake ..
make -j
make install

cd /home/minecraft/voxelizer

mkdir build
cd build
cmake ..

make -j

ls -l
