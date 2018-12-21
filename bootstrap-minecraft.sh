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
  && apt-get clean && rm -rf /var/lib/apt/lists/*

locale-gen --purge en_US.UTF-8 && /bin/echo -e  "LANG=$LANG\nLANGUAGE=$LANGUAGE\n" | tee /etc/default/locale \
  && locale-gen $LANGUAGE \
  && dpkg-reconfigure locales

gem update --no-document --system
gem install --no-document thor
gem list

adduser --system --home /home/minecraft minecraft

cd /home/minecraft

git clone https://github.com/mapcrafter/mapcrafter.git

cd /home/minecraft/mapcrafter
git checkout master

cmake .
make clean
make -j
make install
ldconfig

