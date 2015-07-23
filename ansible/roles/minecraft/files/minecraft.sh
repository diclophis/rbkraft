#!/bin/sh

#set -e
#set -x

RAM=$1
WORLD=$2
MINECRAFT_PORT=$3
export MAVENCRAFT_WRAPPER_PORT=$4
export DYNASTY_SOCK=/tmp/$WORLD-dynasty.sock
MINECRAFT_ROOT=/home/mavencraft
MAVENCRAFT_WRAPPER=/home/mavencraft/mavencraft/minecraft-wrapper/server2.rb
MAVENCRAFT_BLOCKER=/home/mavencraft/mavencraft/minecraft-wrapper/blocker.rb

if [ -e /home/mavencraft/running-$WORLD ];
then
  echo already-running-$WORLD
  exit 1
fi

touch /home/mavencraft/running-$WORLD

mkdir -p $MINECRAFT_ROOT
cd $MINECRAFT_ROOT

echo "mode?"
read line
echo starting "$line"

echo starting-minecraft-wrapper
rm -f $DYNASTY_SOCK
ruby $MAVENCRAFT_WRAPPER ruby $MAVENCRAFT_BLOCKER java -d64 -XX:UseSSE=2 -Xmx$RAM -Xms$RAM -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=8 -XX:+AggressiveOpts -server -jar $MINECRAFT_ROOT/minecraft.jar --bukkit-settings $WORLD-bukkit.yml --port $MINECRAFT_PORT nogui &

sleep 1

0<&-

exit
