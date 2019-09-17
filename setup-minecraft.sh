#!/bin/bash

set -x
set -e

mkdir /home/minecraft/plugins
ln -s /home/minecraft/cache/VirtualPlayers2.jar /home/minecraft/plugins
ln -s /home/minecraft/cache/EssentialsX-2.15.0.60.jar /home/minecraft/plugins

ls -l /home/minecraft/cache

cd /home/minecraft/mapcrafter

mapcrafter_textures.py /home/minecraft/cache/minecraft-client-1.13.2.jar /home/minecraft/mapcrafter/src/data/textures
mapcrafter_textures.py /home/minecraft/cache/minecraft-client-1.12.2.jar /home/minecraft/mapcrafter/src/data/textures

make -j
make install
ldconfig

#################################
cd /home/minecraft
git clone https://github.com/flexible-collision-library/fcl.git
cd fcl
git checkout tags/0.3.3

mkdir build
cd build
cmake ..
make -j
make install

#################################
cd /home/minecraft
git clone https://github.com/topskychen/voxelizer
cd voxelizer
git checkout master

mkdir build
cd build
cmake ..
make -j
