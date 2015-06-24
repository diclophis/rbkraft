#!/bin/bash

# makes map and invokes film

#set -e
#set -x

while true;
do
  echo overviewer-start | logger
  FULL_BACKUP=/home/mavencraft/world

  MAP_BASE=/usr/share/nginx
  LAST_MAP=html

  FULL_MAP=$MAP_BASE/$LAST_MAP

  export FULL_BACKUP
  export FULL_MAP

  echo 'authentic\nsave-all' | nc -w 10 localhost 25566 2>&1 > /dev/null
  echo overviewer-saved | logger

  if [ -e /home/mavencraft/world/level.dat ];
  then
    overviewer.py -v -v -v -v --config /home/mavencraft/mavencraft/scripts/overviewerConfig.py | logger
    echo 'authentic\nsay charted' | nc -w 1 localhost 25566 2>&1 > /dev/null
  fi
  echo overviewer-end | logger
done
