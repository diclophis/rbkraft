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
  if [ -e $MINECRAFT_ROOT/world/level.dat ];
  then
    #cat $MINECRAFT_ROOT/normal-save.cmd | nc -w 1 mavencraft-cluster-ip 31505 2>&1 > /dev/null
    inotifywait -t 1 -e CLOSE $MINECRAFT_ROOT/world/session.lock
    SHUF=$(shuf -i 1-20 -n 1)
    if [ "$SHUF" -eq "10" ];
    then
      echo "took full snap" | logger
      cat $MINECRAFT_ROOT/normal-save.cmd | nc -w 1 mavencraft-cluster-ip 31505 2>&1 > /dev/null
      $MINECRAFT_ROOT/mapper.sh $1
    else
      $MINECRAFT_ROOT/mapper.sh $1
    fi
  else
    cat $MINECRAFT_ROOT/initial-save.cmd | nc -w 1 mavencraft-cluster-ip 31505 2>&1 > /dev/null
    (test -e $MINECRAFT_ROOT/world/session.lock && inotifywait -t 6 -e CLOSE $MINECRAFT_ROOT/world/session.lock) || sleep 1
  fi
done
