#!/bin/bash

set -x
set -e

cd /home/minecraft/mapcrafter

mapcrafter_textures.py /home/minecraft/minecraft-client.jar /home/minecraft/mapcrafter/src/data/textures
mapcrafter_textures.py /home/minecraft/minecraft-client-1.12.jar /home/minecraft/mapcrafter/src/data/textures

make -j
make install
ldconfig
