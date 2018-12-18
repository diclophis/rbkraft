#!/bin/bash

set -x
set -e

cd /home/minecraft/mapcrafter

mapcrafter_textures.py /home/minecraft/minecraft-client.jar /home/minecraft/mapcrafter/src/data/textures
mapcrafter_textures.py /home/minecraft/minecraft-client-1.12.jar /home/minecraft/mapcrafter/src/data/textures

make -j
make install
ldconfig

apt update
apt install -y software-properties-common

add-apt-repository ppa:openscad/releases
apt update

apt install -y openscad meshlab libassimp-dev libccd-dev xvfb

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
