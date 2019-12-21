#!/bin/bash

# makes map and invokes film

#set -e
set -x

MINECRAFT_ROOT=/home/minecraft

FULL_BACKUP=$MINECRAFT_ROOT/minecraft-world/world
FULL_BACKUP2=$MINECRAFT_ROOT/world

FULL_MAP=$MINECRAFT_ROOT/html

export FULL_BACKUP
export FULL_BACKUP2
export FULL_MAP

$MINECRAFT_ROOT/mavencraft/scripts/mapper.sh $1

while true;
do
  sleep 1
  if [ -e $MINECRAFT_ROOT/world/level.dat ];
  then
    cat $MINECRAFT_ROOT/normal-save.cmd | nc -w 1 mavencraft-cluster-ip 31505 2>&1 > /dev/null
    inotifywait -t 30 -e CLOSE $MINECRAFT_ROOT/world/session.lock
    $MINECRAFT_ROOT/mapper.sh $1
  else
    cat $MINECRAFT_ROOT/initial-save.cmd | nc -w 1 mavencraft-cluster-ip 31505 2>&1 > /dev/null
    (test -e $MINECRAFT_ROOT/world/session.lock && inotifywait -t 6 -e CLOSE $MINECRAFT_ROOT/world/session.lock) # || sleep 1
  fi
done
