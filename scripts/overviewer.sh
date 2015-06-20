#!/bin/sh

# makes map and invokes film

#set -e
#set -x

while true;
do
  #screen -r minecraft -x -p 0 -X stuff "say GEN MAP\n"
  #BACKUP_BASE=/opt/backup
  #LAST_BACKUP=`ls -1tr $BACKUP_BASE | tail -n 1`
  #FULL_BACKUP=$BACKUP_BASE/$LAST_BACKUP

  FULL_BACKUP=/opt/minecraft/world

  MAP_BASE=/usr/share/nginx
  LAST_MAP=html

  FULL_MAP=$MAP_BASE/$LAST_MAP

  export FULL_BACKUP
  export FULL_MAP

  overviewer.py -v -v -v -v --config /home/mavencraft/mavencraft/scripts/overviewerConfig.py

  #sleep 30
  #sh ~/mavencraft/scripts/film.sh a b foo
  #screen -r minecraft -x -p 0 -X stuff "say MAP DONE\n"
done
