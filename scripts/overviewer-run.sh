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

$MINECRAFT_ROOT/mavencraft/scripts/mapper.sh $1 -F

while true;
do
  if [ -e $MINECRAFT_ROOT/world/level.dat ];
  then
    cat $MINECRAFT_ROOT/normal-save.cmd | nc -w 1 localhost 25566 2>&1 > /dev/null
    #cat $MINECRAFT_ROOT/normal-save.cmd | nc -w 1 localhost 25567 2>&1 > /dev/null
    inotifywait -t 1 -e CLOSE $MINECRAFT_ROOT/world/session.lock
    SHUF=$(shuf -i 1-20 -n 1)
    if [ "$SHUF" -eq "10" ];
    then
      echo "took full snap" | logger
      $MINECRAFT_ROOT/mapper.sh $1 -F
    else
      $MINECRAFT_ROOT/mapper.sh $1
    fi
  else
    cat $MINECRAFT_ROOT/initial-save.cmd | nc -w 1 localhost 25566 2>&1 > /dev/null
    #cat $MINECRAFT_ROOT/initial-save.cmd | nc -w 1 localhost 25567 2>&1 > /dev/null
    (test -e $MINECRAFT_ROOT/world/session.lock && inotifywait -t 6 -e CLOSE $MINECRAFT_ROOT/world/session.lock) || sleep 1
  fi
done
  
  #if [ -e $MINECRAFT_ROOT/minecraft-world/world/level.dat -a -e $MINECRAFT_ROOT/world/level.dat ];
    #echo overviewer-start | logger
    #echo overviewer-end | logger
    #echo overview-chart | logger
    #echo -e 'authentic\nsave-on\nsave-all' | nc -w 1 localhost 25566 2>&1 > /dev/null
    #echo -e 'authentic\nsave-on\nsave-all' | nc -w 1 localhost 25567 2>&1 > /dev/null
    #overviewer.py -p $1 --simple-output --config /home/mavencraft/mavencraft/scripts/overviewerConfig.py 2>&1 | logger -t ov-py
    #echo overview-charted | logger
    #echo overview-wait | logger
    #sleep 16
    #echo -e 'authentic\nsetworldspawn 0 65 0\nsave-on\nsave-all\n' | nc -w 10 localhost 25566 2>&1 > /dev/null
    #echo -e 'authentic\nsetworldspawn 0 65 0\nsave-on\nsave-all\n' | nc -w 10 localhost 25567 2>&1 > /dev/null
    #echo overviewer-saved | logger
