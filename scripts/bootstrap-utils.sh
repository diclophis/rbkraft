#!/bin/sh

set -e
set -x

# binvox ###################################
curl -v -L -o /var/tmp/binvox "http://www.patrickmin.com/binvox/linux64/binvox?rnd=1576566018642542"
chmod +x /var/tmp/binvox
mv /var/tmp/binvox /usr/bin/binvox

# mapcrafter ###########################
cd /home/app
git clone https://github.com/miclav/mapcrafter.git

cd /home/app/mapcrafter
git checkout world117

cmake .
make clean
make -j2
make install
ldconfig

apt-get update && apt-get install -y python-is-python2 libeigen3-dev

mapcrafter_textures.py /home/app/cache/minecraft-client-1.17.1.jar /home/app/mapcrafter/src/data/textures
mapcrafter_textures.py /home/app/cache/minecraft-server-1.17.1.jar /home/app/mapcrafter/src/data/textures

make -j2
make install
ldconfig

# fcl #################################
cd /home/app
git clone https://github.com/flexible-collision-library/fcl.git
cd fcl
git checkout tags/0.3.3

mkdir build
cd build
cmake ..
make -j2
make install

# voxelizer #################################
cd /home/app
git clone https://github.com/topskychen/voxelizer
cd voxelizer
git checkout master
git submodule init
git submodule update

mkdir build
cd build
cmake ..
make -j2
