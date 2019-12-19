#!/bin/bash

set -x
set -e

mkdir /home/minecraft/plugins
ln -s /home/minecraft/cache/VirtualPlayers.jar /home/minecraft/plugins
ln -s /home/minecraft/cache/EssentialsX-2.17.1.25.jar /home/minecraft/plugins

ls -l /home/minecraft/cache

apt update && apt install -y openssh-client
mkdir ~/.ssh
touch ~/.ssh/known_hosts
ssh-keygen -R github.com
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
cd /home/minecraft
git clone https://github.com/mapcrafter/mapcrafter.git
#git clone git@github.com:mapcrafter/mapcrafter.git

cd /home/minecraft/mapcrafter
git checkout world113

cmake .
make clean
make -j16
make install
ldconfig

mapcrafter_textures.py /home/minecraft/cache/minecraft-client-1.12.2.jar /home/minecraft/mapcrafter/src/data/textures
mapcrafter_textures.py /home/minecraft/cache/minecraft-client-1.13.2.jar /home/minecraft/mapcrafter/src/data/textures
mapcrafter_textures.py /home/minecraft/cache/craftbukkit-1.14.4-R0.1-SNAPSHOT.jar /home/minecraft/mapcrafter/src/data/textures

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

curl -v -L -o /var/tmp/binvox "http://www.patrickmin.com/binvox/linux64/binvox?rnd=1576566018642542"
chmod +x /var/tmp/binvox
mv /var/tmp/binvox /usr/bin/binvox
