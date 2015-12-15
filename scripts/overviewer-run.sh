#!/bin/bash

# makes map and invokes film

#set -e
#set -x

FULL_BACKUP=/home/mavencraft/minecraft-world/world
FULL_BACKUP2=/home/mavencraft/mavencraft-world/world

MAP_BASE=/usr/share/nginx
LAST_MAP=html
FULL_MAP=$MAP_BASE/$LAST_MAP
rm -Rf /tmp/dump
mkdir /tmp/dump
mv -f $FULL_MAP/* /tmp/dump
mkdir -p $FULL_MAP

export FULL_BACKUP
export FULL_BACKUP2
export FULL_MAP

while true;
do
  #echo overviewer-start | logger
  if [ -e /home/mavencraft/minecraft-world/world/level.dat -a -e /home/mavencraft/mavencraft-world/world/level.dat ];
  then
    #echo overview-chart | logger
    #echo -e 'authentic\nsave-on\nsave-all' | nc -w 1 localhost 25566 2>&1 > /dev/null
    #echo -e 'authentic\nsave-on\nsave-all' | nc -w 1 localhost 25567 2>&1 > /dev/null
    cat /home/mavencraft/mavencraft/scripts/normal-save.cmd | nc -w 1 localhost 25566 2>&1 > /dev/null
    cat /home/mavencraft/mavencraft/scripts/normal-save.cmd | nc -w 1 localhost 25567 2>&1 > /dev/null
    inotifywait -t 6 -e CLOSE /home/mavencraft/mavencraft-world/world/session.lock
    #overviewer.py -p $1 --simple-output --config /home/mavencraft/mavencraft/scripts/overviewerConfig.py 2>&1 | logger -t ov-py
    /home/mavencraft/mavencraft/scripts/mapper.sh    
    #echo overview-charted | logger
  else
    #echo overview-wait | logger
    #sleep 16
    #echo -e 'authentic\nsetworldspawn 0 65 0\nsave-on\nsave-all\n' | nc -w 10 localhost 25566 2>&1 > /dev/null
    #echo -e 'authentic\nsetworldspawn 0 65 0\nsave-on\nsave-all\n' | nc -w 10 localhost 25567 2>&1 > /dev/null
    cat /home/mavencraft/mavencraft/scripts/initial-save.cmd | nc -w 1 localhost 25566 2>&1 > /dev/null
    cat /home/mavencraft/mavencraft/scripts/initial-save.cmd | nc -w 1 localhost 25567 2>&1 > /dev/null
    (test -e /home/mavencraft/mavencraft-world/world/session.lock && inotifywait -t 6 -e CLOSE /home/mavencraft/mavencraft-world/world/session.lock) || sleep 1
    #echo overviewer-saved | logger
  fi
  #echo overviewer-end | logger
done
