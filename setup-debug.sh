#!/bin/bash

set -e
set -x

#cd /home/minecraft
#git clone https://github.com/sylefeb/VoxSurf.git
#
#cd /home/minecraft/VoxSurf
#git checkout master
#
#git config --file=.gitmodules submodule.LibSL-small.url https://github.com/sylefeb/LibSL-small.git
#git submodule sync
#git submodule update --init --recursive --remote
#
##git submodule init && git submodule update
#
#ls -la
#
#ls -la LibSL-small
#
##echo '#define SRC_PATH "/var/tmp"' > path.h
##g++ -ILibSL-small -ILibSL-small/LibSL main.cpp -o voxsurf
#
#cp /var/tmp/voxsurf-main.cpp main.cpp
#
#cmake .
#make -j
#
#ls -la

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
