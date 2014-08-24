#!/bin/sh

# makes map and invokes film

set -e

screen -r minecraft -x -p 0 -X stuff "say GEN MAP\n"

BACKUP_BASE=/opt/backup
LAST_BACKUP=`ls -1tr $BACKUP_BASE | tail -n 1`

FULL_BACKUP=$BACKUP_BASE/$LAST_BACKUP

MAP_BASE=/usr/share/nginx
LAST_MAP=html

FULL_MAP=$MAP_BASE/$LAST_MAP

#screen -r minecraft -x -p 0 -X stuff "/say begin overviewer generation\n"

#$FULL_BACKUP $FULL_MAP
export FULL_BACKUP
export FULL_MAP

overviewer.py -v --config ~/mavencraft/scripts/overviewerConfig.py

#--rendermodes=smooth-lighting,smooth-night $FULL_BACKUP $FULL_MAP

#sh ~/mavencraft/scripts/film.sh

screen -r minecraft -x -p 0 -X stuff "say MAP DONE\n"
