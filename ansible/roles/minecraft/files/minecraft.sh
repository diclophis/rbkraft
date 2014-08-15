#!/bin/sh

set -e

RAM=1500M
MINECRAFT_JAR=/root/minecraft.jar
MINECRAFT_ROOT=/opt/minecraft
MAVENCRAFT_WRAPPER=/root/mavencraft/minecraft-wrapper/server.rb
MAVENCRAFT_WRAPPER_SOCK=/tmp/minecraft-wrapper.sock

mkdir -p $MINECRAFT_ROOT
cd $MINECRAFT_ROOT

touch $MAVENCRAFT_WRAPPER_SOCK
rm $MAVENCRAFT_WRAPPER_SOCK

ruby $MAVENCRAFT_WRAPPER java -d64 -XX:UseSSE=2 -Xmx$RAM -Xms$RAM -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -server -jar $MINECRAFT_JAR nogui
