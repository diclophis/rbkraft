#!/bin/sh

set -x

RAM=$1
WORLD=$2
MINECRAFT_PORT=$3
export MAVENCRAFT_WRAPPER_PORT=$4
JAR=$5
WORLD=$6
MINECRAFT_ROOT=/home/app

mkdir -p $MINECRAFT_ROOT/tmp

export DYNASTY_SOCK=$MINECRAFT_ROOT/tmp/$WORLD-dynasty.sock
MAVENCRAFT_WRAPPER=$MINECRAFT_ROOT/minecraft-wrapper/server2.rb

cd $MINECRAFT_ROOT

#LOG_CONF=-Dlog4j.configurationFile=log4j2.xml
LOG_CONF=

java --version

VM_ARGS="-mx${RAM} -Xmx${RAM} -Xms${RAM} -XX:MaxGCPauseMillis=1 -XX:+UseG1GC -XX:ParallelGCThreads=1024 -XX:ConcGCThreads=1024 -XX:InitiatingHeapOccupancyPercent=0 -XX:+AggressiveOpts"

ruby $MAVENCRAFT_WRAPPER java ${LOG_CONF} ${JVM_ARGS} -server -jar $JAR --port $MINECRAFT_PORT -c config/${WORLD}-server.properties nogui
