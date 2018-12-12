#!/bin/sh

set -x

RAM=$1
WORLD=$2
MINECRAFT_PORT=$3
export MAVENCRAFT_WRAPPER_PORT=$4
MINECRAFT_ROOT=/home/minecraft

mkdir -p $MINECRAFT_ROOT/tmp

export DYNASTY_SOCK=$MINECRAFT_ROOT/tmp/$WORLD-dynasty.sock
MAVENCRAFT_WRAPPER=$MINECRAFT_ROOT/minecraft-wrapper/server2.rb

cd $MINECRAFT_ROOT

LOG_CONF=-Dlog4j.configurationFile=log4j2.xml
LOG_CONF=""

ruby $MAVENCRAFT_WRAPPER java ${LOG_CONF} -XX:UseSSE=2 -Xmx$RAM -Xms$RAM -XX:+UseConcMarkSweepGC -XX:ParallelGCThreads=32 -XX:+AggressiveOpts -XX:+CMSClassUnloadingEnabled -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -server -jar $MINECRAFT_ROOT/minecraft.jar --port $MINECRAFT_PORT nogui
