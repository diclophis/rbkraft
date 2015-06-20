#!/bin/sh

set -e
set -x

RAM=1500M
MINECRAFT_ROOT=/opt/minecraft
MAVENCRAFT_WRAPPER=/home/mavencraft/mavencraft/minecraft-wrapper/server2.rb
MAVENCRAFT_BLOCKER=/home/mavencraft/mavencraft/minecraft-wrapper/blocker.rb

mkdir -p $MINECRAFT_ROOT
cd $MINECRAFT_ROOT

pkill -9 -f java || true

rm -Rf /opt/minecraft/world*
rm -f /tmp/dynasty.sock

#sh /home/mavencraft/mavencraft/scripts/overviewer.sh &

ruby $MAVENCRAFT_WRAPPER ruby $MAVENCRAFT_BLOCKER java -d64 -XX:UseSSE=2 -Xmx$RAM -Xms$RAM -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -server -jar $MINECRAFT_ROOT/minecraft.jar nogui &
MCPID=$!

nc -l 0.0.0.0 20021

pkill -9 -f java || true
pkill -9 -f ruby || true
