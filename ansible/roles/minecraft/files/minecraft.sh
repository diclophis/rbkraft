#!/bin/sh

#set -e
set -x

RAM=$1
WORLD=$2
MINECRAFT_PORT=$3
export MAVENCRAFT_WRAPPER_PORT=$4
MINECRAFT_ROOT=/home/minecraft

mkdir -p $MINECRAFT_ROOT/tmp

export DYNASTY_SOCK=$MINECRAFT_ROOT/tmp/$WORLD-dynasty.sock
MAVENCRAFT_WRAPPER=$MINECRAFT_ROOT/mavencraft/minecraft-wrapper/server2.rb
MAVENCRAFT_BLOCKER=$MINECRAFT_ROOT/mavencraft/minecraft-wrapper/blocker.rb

if [ -e $MINECRAFT_ROOT/running-$WORLD ];
then
  echo already-running-$WORLD
  exit 1
fi

touch $MINECRAFT_ROOT/running-$WORLD

mkdir -p $MINECRAFT_ROOT
cd $MINECRAFT_ROOT

echo starting-minecraft-wrapper
rm -f $DYNASTY_SOCK

LOG_CONF=-Dlog4j.configurationFile=log4j2.xml
#LOG_CONF=""

ruby $MAVENCRAFT_WRAPPER ruby $MAVENCRAFT_BLOCKER java ${LOG_CONF} -d64 -XX:UseSSE=2 -Xmx$RAM -Xms$RAM -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:ParallelGCThreads=32 -XX:+AggressiveOpts -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -server -jar $MINECRAFT_ROOT/minecraft.jar --bukkit-settings $WORLD-bukkit.yml --port $MINECRAFT_PORT nogui
