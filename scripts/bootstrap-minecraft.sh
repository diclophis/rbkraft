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


curl_sha_checksum_fetch \
  "minecraft-server-1.13.2.jar" \
  "https://launcher.mojang.com/v1/objects/3737db93722a9e39eeada7c27e7aca28b144ffa7/server.jar" \
  "3737db93722a9e39eeada7c27e7aca28b144ffa7"

curl_sha_checksum_fetch \
  "minecraft-client-1.13.2.jar" \
  "https://launcher.mojang.com/v1/objects/30bfe37a8db404db11c7edf02cb5165817afb4d9/client.jar" \
  "30bfe37a8db404db11c7edf02cb5165817afb4d9"

curl_sha_checksum_fetch \
  "minecraft-server-1.12.2.jar" \
  "https://launcher.mojang.com/v1/objects/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar" \
  "886945bfb2b978778c3a0288fd7fab09d315b25f"

curl_sha_checksum_fetch \
  "minecraft-client-1.12.2.jar" \
  "https://launcher.mojang.com/v1/objects/0f275bc1547d01fa5f56ba34bdc87d981ee12daf/client.jar" \
  "0f275bc1547d01fa5f56ba34bdc87d981ee12daf"

curl_sha_checksum_fetch \
  "VirtualPlayers.jar" \
  "https://media.forgecdn.net/files/2763/496/VirtualPlayers.jar" \
  "4e43d777c7aba08882ff2f9ef24850f80e90804d"

curl_sha_checksum_fetch \
  "EssentialsX-2.17.2.11.jar" \
  "https://ci.ender.zone/job/EssentialsX/842/artifact/Essentials/target/EssentialsX-2.17.2.11.jar" \
  "3b9fe4f9d12b0eb240461dc8cc619b98d209d6da"

curl_sha_checksum_fetch \
  "craftbukkit-server-1.12.2.jar" \
  "https://cdn.getbukkit.org/craftbukkit/craftbukkit-1.12.2.jar" \
  "3aefd516366d91cc8d182bb8bdad46b8ba7d13c2"

curl_sha_checksum_fetch \
  "craftbukkit-1.14.4-R0.1-SNAPSHOT.jar" \
  "https://cdn.getbukkit.org/craftbukkit/craftbukkit-1.14.4-R0.1-SNAPSHOT.jar" \
  "52e383da70af9c795c967c92b5ff82e153f1b294"

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
