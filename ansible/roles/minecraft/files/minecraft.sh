#!/bin/sh

set -e
set -x

RAM=1500M
MINECRAFT_JAR=/root/minecraft.jar
MINECRAFT_ROOT=/opt/minecraft
MAVENCRAFT_WRAPPER=/root/mavencraft/minecraft-wrapper/server2.rb
MAVENCRAFT_BLOCKER=/root/mavencraft/minecraft-wrapper/blocker.rb

mkdir -p $MINECRAFT_ROOT
cd $MINECRAFT_ROOT

ruby $MAVENCRAFT_WRAPPER $MAVENCRAFT_BLOCKER java -d64 -XX:UseSSE=2 -Xmx$RAM -Xms$RAM -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=2 -XX:+AggressiveOpts -server -jar $MINECRAFT_JAR nogui
