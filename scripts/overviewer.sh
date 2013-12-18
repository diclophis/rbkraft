#!/bin/sh

# makes map and invokes film

BACKUP_BASE=/mnt/minecraft-disk-2/backups
LAST_BACKUP=`ls -1tr $BACKUP_BASE | tail -n 1`

FULL_BACKUP=$BACKUP_BASE/$LAST_BACKUP

MAP_BASE=/mnt/minecraft-disk-2/maps
LAST_MAP=current

FULL_MAP=$MAP_BASE/$LAST_MAP

screen -r minecraft -x -p 0 -X stuff "/say begin overviewer generation\n"

overviewer.py -v -p 1 --rendermodes=smooth-lighting,smooth-night $FULL_BACKUP $FULL_MAP

sh ~/mavencraft/scripts/film.sh
