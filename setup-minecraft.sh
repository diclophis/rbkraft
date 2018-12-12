#!/bin/bash

set -x
set -e

cd /home/minecraft/mapcrafter
git checkout master

make clean
make -j
make install
ldconfig

mapcrafter_textures.py /home/minecraft/minecraft-client.jar /home/minecraft/mapcrafter/src/data/textures

make -j
make install
make install
ldconfig
