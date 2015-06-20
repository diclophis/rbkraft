#!/bin/bash

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

  echo -e 'authentic\nsave-all' | nc -w 30 -4 -c -i 1 -H 1 -I 2 -L 3 -t localhost 25566 | grep 'Save complete'
  SAVED=$?
  if [ $SAVED = 0 ];
  then
    overviewer.py -v -v -v -v --config /home/mavencraft/mavencraft/scripts/overviewerConfig.py | logger
    echo 'authentic\nsay charted' | nc -w 1 localhost 25566
  fi
  echo overviewer-end | logger
done
