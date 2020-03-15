#!/bin/bash

# makes map and invokes film

#set -e
#set -x

MINECRAFT_ROOT=/home/app

while true;
do
  sleep 5

  if [ -e $MINECRAFT_ROOT/world/level.dat ];
  then
    cat $MINECRAFT_ROOT/scripts/normal-save.cmd | nc -w 1 localhost 25566 2>&1 > /dev/null
    inotifywait -t 30 -e CLOSE $MINECRAFT_ROOT/world/session.lock
    $MINECRAFT_ROOT/scripts/mapper.sh $1
  else
    cat $MINECRAFT_ROOT/scripts/initial-save.cmd | nc -w 1 localhost 25566 2>&1 > /dev/null
    (test -e $MINECRAFT_ROOT/world/session.lock && inotifywait -t 30 -e CLOSE $MINECRAFT_ROOT/world/session.lock) # || sleep 1
  fi
done
