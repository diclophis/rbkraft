#!/bin/sh

#set -e
#set -x

if [ -e /home/mavencraft/running ];
then
  echo already-running
  exit 1
fi

touch /home/mavencraft/running
rm -f /tmp/dynasty.sock

pkill -9 -f overviewer || true
pkill -9 -f java || true
pkill -9 -f java || true
pkill -9 -f ruby || true

RAM=$1
PROCS_PER_TASK=$2
MINECRAFT_ROOT=/home/mavencraft
MAVENCRAFT_WRAPPER=/home/mavencraft/mavencraft/minecraft-wrapper/server2.rb
MAVENCRAFT_BLOCKER=/home/mavencraft/mavencraft/minecraft-wrapper/blocker.rb

mkdir -p $MINECRAFT_ROOT
cd $MINECRAFT_ROOT

echo "mode?"
read line
echo starting "$line"

echo starting-minecraft
ruby $MAVENCRAFT_WRAPPER ruby $MAVENCRAFT_BLOCKER java -d64 -XX:UseSSE=2 -Xmx$RAM -Xms$RAM -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=8 -XX:+AggressiveOpts -server -jar $MINECRAFT_ROOT/minecraft.jar nogui &

echo starting-overviewer
sh /home/mavencraft/mavencraft/scripts/overviewer.sh $PROCS_PER_TASK &

#echo starting-blocker
#while true
#do
#  if [ -e /home/mavencraft/running ];
#  then
#    echo running
#    sleep 60
#  else
#    rm -f /tmp/dynasty.sock
#    echo stopping
#    exit
#  fi
#done
sleep 1


