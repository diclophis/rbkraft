#!/bin/sh

#set -e
#set -x

pgrep "ruby"
OK_TO_RUN_WHEN_ONE=$?

if [ $OK_TO_RUN_WHEN_ONE = 0 ];
then
  ps f -U root
  ps f -U www-data
  ps f -U mavencraft
  tail -n 16 /var/log/syslog
  sleep 1
  exit 1
fi;

RAM=$1
PROCS_PER_TASK=$2
MINECRAFT_ROOT=/home/mavencraft
MAVENCRAFT_WRAPPER=/home/mavencraft/mavencraft/minecraft-wrapper/server2.rb
MAVENCRAFT_BLOCKER=/home/mavencraft/mavencraft/minecraft-wrapper/blocker.rb

mkdir -p $MINECRAFT_ROOT
cd $MINECRAFT_ROOT

pkill -9 -f java || true

echo "mode?"
read line
echo starting "$line"

rm -f /tmp/dynasty.sock

echo starting-minecraft
ruby $MAVENCRAFT_WRAPPER ruby $MAVENCRAFT_BLOCKER java -d64 -XX:UseSSE=2 -Xmx$RAM -Xms$RAM -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=4 -XX:+AggressiveOpts -server -jar $MINECRAFT_ROOT/minecraft.jar nogui &

echo starting-overviewer
sudo -u mavencraft sh /home/mavencraft/mavencraft/scripts/overviewer.sh $PROCS_PER_TASK &

echo starting-blocker
touch /home/mavencraft/running
while true
do
  if [ -e /home/mavencraft/running ];
  then
    echo running
    sleep 60
  else
    echo stopping
    exit
  fi
done


