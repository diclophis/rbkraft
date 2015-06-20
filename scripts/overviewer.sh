#!/bin/sh

# makes map and invokes film

#set -e
#set -x

while true;
do
  echo overviewer-start | logger
  FULL_BACKUP=/opt/minecraft/world

  MAP_BASE=/usr/share/nginx
  LAST_MAP=html

  FULL_MAP=$MAP_BASE/$LAST_MAP

  export FULL_BACKUP
  export FULL_MAP

  echo 'authentic\nsave-all' | nc -w 10 localhost 25566 | grep 'Save complete'
  SAVED=$?
  if [ $SAVED = 0 ];
  then
    overviewer.py -v -v -v -v --config /home/mavencraft/mavencraft/scripts/overviewerConfig.py | logger
    echo 'authentic\nsay charted' | nc -w 1 localhost 25566
  fi
  echo overviewer-end | logger
done
