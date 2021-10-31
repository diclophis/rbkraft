#!/bin/sh

set -e
set -x

apt update && apt install -y software-properties-common

add-apt-repository ppa:openscad/releases
apt update

apt-get update \
  && apt-get upgrade --no-install-recommends -y \
  && apt-get install --no-install-recommends -y \
       openscad meshlab libassimp-dev libccd-dev xvfb \
       openssh-client \
       locales ruby2.5 rake git \
       apache2 apache2-utils \
       docker-registry \
       libpng-dev libjpeg-dev \
       curl \
       vim \
       nginx \
       netcat \
       jq \
       strace \
       imagemagick \
       htop \
       ruby-bundler rake ruby2.5-dev build-essential make \
       default-jre \
       python-numpy nginx cmake libassimp-dev m4 autoconf libtool libboost-dev libboost-all-dev libboost-thread-dev libboost-filesystem-dev libboost-test-dev inotify-tools \
       ffmpeg \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

locale-gen --purge en_US.UTF-8 && /bin/echo -e  "LANG=$LANG\nLANGUAGE=$LANGUAGE\n" | tee /etc/default/locale \
  && locale-gen $LANGUAGE \
  && dpkg-reconfigure locales

gem update --no-document --system 3.0.6
gem install --no-document thor
gem list
bundler --version

useradd --home-dir /home/app --create-home --shell /bin/bash app

function curl_sha_checksum_fetch {
  FILENAME="${1}"
  REPO_URL="${2}"
  SHA1="${3}"
  PREFIX="${4}"

  mkdir -p /home/app/cache

  curl -LS -s -z /home/app/cache/${SHA1}-${FILENAME} -o /home/app/cache/${SHA1}-${FILENAME} --location ${REPO_URL}

  ln -s /home/app/cache/${SHA1}-${FILENAME} /home/app/cache/${FILENAME}

  echo "${SHA1}  /home/app/cache/${SHA1}-${FILENAME}" | shasum -c || (shasum /home/app/cache/${SHA1}-${FILENAME} && exit 1)
}


# 1.15.2
#https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar
#https://launcher.mojang.com/v1/objects/e3f78cd16f9eb9a52307ed96ebec64241cc5b32d/client.jar

# 1.14.4
#https://launcher.mojang.com/v1/objects/3dc3d84a581f14691199cf6831b71ed1296a9fdf/server.jar
#https://launcher.mojang.com/v1/objects/8c325a0c5bd674dd747d6ebaa4c791fd363ad8a9/client.jar

# 1.17.1
#https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
#https://launcher.mojang.com/v1/objects/8d9b65467c7913fcf6f5b2e729d44a1e00fde150/client.jar

#curl_sha_checksum_fetch \
#  "minecraft-server-1.13.2.jar" \
#  "https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar" \
#  "3737db93722a9e39eeada7c27e7aca28b144ffa7"
#
#curl_sha_checksum_fetch \
#  "minecraft-client-1.13.2.jar" \
#  "https://launcher.mojang.com/v1/objects/30bfe37a8db404db11c7edf02cb5165817afb4d9/client.jar" \
#  "30bfe37a8db404db11c7edf02cb5165817afb4d9"
#
#curl_sha_checksum_fetch \
#  "minecraft-server-1.12.2.jar" \
#  "https://launcher.mojang.com/v1/objects/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar" \
#  "886945bfb2b978778c3a0288fd7fab09d315b25f"
#
#curl_sha_checksum_fetch \
#  "minecraft-client-1.12.2.jar" \
#  "https://launcher.mojang.com/v1/objects/0f275bc1547d01fa5f56ba34bdc87d981ee12daf/client.jar" \
#  "0f275bc1547d01fa5f56ba34bdc87d981ee12daf"

curl_sha_checksum_fetch \
  "minecraft-client-1.17.1.jar" \
  "https://launcher.mojang.com/v1/objects/8d9b65467c7913fcf6f5b2e729d44a1e00fde150/client.jar" \
  "8d9b65467c7913fcf6f5b2e729d44a1e00fde150"

curl_sha_checksum_fetch \
  "minecraft-server-1.17.1.jar" \
  "https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar" \
  "a16d67e5807f57fc4e550299cf20226194497dc2"

curl_sha_checksum_fetch \
  "VirtualPlayers.jar" \
  "https://media.forgecdn.net/files/2843/592/VirtualPlayers.jar" \
  "d2057a48a84e018f5c2c7d0dc7263e94658900be"

curl_sha_checksum_fetch \
  "EssentialsX-2.19.1-dev+26-e43f06b.jar" \
  "https://ci.ender.zone/job/EssentialsX/lastSuccessfulBuild/artifact/jars/EssentialsX-2.19.1-dev+26-e43f06b.jar" \
  "137d1b0fd86f26ca1bbf110f4897548fdb9847c2"

#curl_sha_checksum_fetch \
#  "craftbukkit-server-1.12.2.jar" \
#  "https://cdn.getbukkit.org/craftbukkit/craftbukkit-1.12.2.jar" \
#  "3aefd516366d91cc8d182bb8bdad46b8ba7d13c2"
#
#curl_sha_checksum_fetch \
#  "craftbukkit-1.14.4-R0.1-SNAPSHOT.jar" \
#  "https://cdn.getbukkit.org/craftbukkit/craftbukkit-1.14.4-R0.1-SNAPSHOT.jar" \
#  "52e383da70af9c795c967c92b5ff82e153f1b294"

#curl_sha_checksum_fetch \
#  "craftbukkit-1.14.4-R0.1-SNAPSHOT.jar" \
#  "https://cdn.getbukkit.org/craftbukkit/craftbukkit-1.14.4-R0.1-SNAPSHOT.jar" \
#  "52e383da70af9c795c967c92b5ff82e153f1b294"

curl_sha_checksum_fetch \
  "craftbukkit-1.17.1.jar" \
  "https://download.getbukkit.org/craftbukkit/craftbukkit-1.17.1.jar" \
  "f4842ec81490dd1c9699eda1fccbdc5e56738771"

mkdir /home/app/plugins
chown app: /home/app/plugins

ln -s /home/app/cache/VirtualPlayers.jar /home/app/plugins
ln -s /home/app/cache/EssentialsX-2.19.1-dev+26-e43f06b.jar /home/app/plugins

ls -l /home/app/cache

mkdir ~/.ssh
touch ~/.ssh/known_hosts
ssh-keygen -R github.com
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

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

mapcrafter_textures.py /home/app/cache/minecraft-client-1.17.1.jar /home/app/mapcrafter/src/data/textures
mapcrafter_textures.py /home/app/cache/minecraft-server-1.17.1.jar /home/app/mapcrafter/src/data/textures
mapcrafter_textures.py /home/app/cache/craftbukkit-1.17.1.jar /home/app/mapcrafter/src/data/textures

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

# binvox ###################################
curl -v -L -o /var/tmp/binvox "http://www.patrickmin.com/binvox/linux64/binvox?rnd=1576566018642542"
chmod +x /var/tmp/binvox
mv /var/tmp/binvox /usr/bin/binvox
