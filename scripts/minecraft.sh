#!/bin/sh

set -x

RAM=$1
WORLD=$2
MINECRAFT_PORT=$3
export MAVENCRAFT_WRAPPER_PORT=$4
JAR=$5
MINECRAFT_ROOT=/home/minecraft

mkdir -p $MINECRAFT_ROOT/tmp

export DYNASTY_SOCK=$MINECRAFT_ROOT/tmp/$WORLD-dynasty.sock
MAVENCRAFT_WRAPPER=$MINECRAFT_ROOT/minecraft-wrapper/server2.rb

cd $MINECRAFT_ROOT

#LOG_CONF=-Dlog4j.configurationFile=log4j2.xml
LOG_CONF=

java --version

#JVM_ARGS="-mx${RAM} -Xmx${RAM} -Xms${RAM} -XX:MaxGCPauseMillis=1 -XX:+UseG1GC -XX:ParallelGCThreads=1024 -XX:ConcGCThreads=1024 -XX:InitiatingHeapOccupancyPercent=70 -XX:+AggressiveOpts"
#JVM_ARGS="-mx${RAM} -Xmx${RAM} -Xms${RAM} -XX:MaxGCPauseMillis=33 -XX:+UseG1GC -XX:ParallelGCThreads=1 -XX:ConcGCThreads=1 -XX:InitiatingHeapOccupancyPercent=0 -XX:+AggressiveOpts"
#VM_ARGS="-mx${RAM} -Xmx${RAM} -Xms${RAM} -XX:MaxGCPauseMillis=1000 -XX:+UseG1GC -XX:ParallelGCThreads=8 -XX:ConcGCThreads=4 -XX:InitiatingHeapOccupancyPercent=0 -XX:+AggressiveOpts"
#VM_ARGS="-mx${RAM} -Xmx${RAM} -Xms${RAM} -XX:MaxGCPauseMillis=1000 -XX:+UseG1GC -XX:ParallelGCThreads=8 -XX:ConcGCThreads=4 -XX:InitiatingHeapOccupancyPercent=0"
VM_ARGS="-mx${RAM} -Xmx${RAM} -Xms${RAM} -XX:MaxGCPauseMillis=1 -XX:+UseG1GC -XX:ParallelGCThreads=1 -XX:ConcGCThreads=1 -XX:InitiatingHeapOccupancyPercent=70 -XX:+AggressiveOpts"

ruby $MAVENCRAFT_WRAPPER java ${LOG_CONF} ${JVM_ARGS} -server -jar $JAR --port $MINECRAFT_PORT nogui
