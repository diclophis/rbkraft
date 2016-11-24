#!/bin/bash

# makes map and invokes film

#set -e
set -x

MINECRAFT_ROOT=/home/minecraft

FULL_BACKUP=$MINECRAFT_ROOT/minecraft-world/world
FULL_BACKUP2=$MINECRAFT_ROOT/mavencraft-world/world

FULL_MAP=$MINECRAFT_ROOT/html

export FULL_BACKUP
export FULL_BACKUP2
export FULL_MAP

while true;
do
  if [ -e $MINECRAFT_ROOT/minecraft-world/world/level.dat -a -e $MINECRAFT_ROOT/mavencraft-world/world/level.dat ];
  then
    cat $MINECRAFT_ROOT/mavencraft/scripts/normal-save.cmd | nc -w 1 localhost 25566 2>&1 > /dev/null
    cat $MINECRAFT_ROOT/mavencraft/scripts/normal-save.cmd | nc -w 1 localhost 25567 2>&1 > /dev/null
    inotifywait -t 6 -e CLOSE $MINECRAFT_ROOT/mavencraft-world/world/session.lock
    $MINECRAFT_ROOT/mavencraft/scripts/mapper.sh    
  else
    cat $MINECRAFT_ROOT/mavencraft/scripts/initial-save.cmd | nc -w 1 localhost 25566 2>&1 > /dev/null
    cat $MINECRAFT_ROOT/mavencraft/scripts/initial-save.cmd | nc -w 1 localhost 25567 2>&1 > /dev/null
    (test -e $MINECRAFT_ROOT/mavencraft-world/world/session.lock && inotifywait -t 6 -e CLOSE $MINECRAFT_ROOT/mavencraft-world/world/session.lock) || sleep 1
  fi
done

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
