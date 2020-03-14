#!/bin/bash

set -x
set -e

mkdir /home/app/plugins
chown app: /home/app/plugins

ln -s /home/app/cache/VirtualPlayers.jar /home/app/plugins
ln -s /home/app/cache/EssentialsX-2.17.2.11.jar /home/app/plugins

ls -l /home/app/cache

mkdir ~/.ssh
touch ~/.ssh/known_hosts
ssh-keygen -R github.com
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

# mapcrafter ###########################
cd /home/app
git clone https://github.com/mapcrafter/mapcrafter.git

cd /home/app/mapcrafter
git checkout world113

cmake .
make clean
make -j2
make install
ldconfig

mapcrafter_textures.py /home/app/cache/minecraft-client-1.12.2.jar /home/app/mapcrafter/src/data/textures
mapcrafter_textures.py /home/app/cache/minecraft-client-1.13.2.jar /home/app/mapcrafter/src/data/textures
mapcrafter_textures.py /home/app/cache/craftbukkit-1.14.4-R0.1-SNAPSHOT.jar /home/app/mapcrafter/src/data/textures

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

mkdir build
cd build
cmake ..
make -j2

# binvox ###################################
curl -v -L -o /var/tmp/binvox "http://www.patrickmin.com/binvox/linux64/binvox?rnd=1576566018642542"
chmod +x /var/tmp/binvox
mv /var/tmp/binvox /usr/bin/binvox
