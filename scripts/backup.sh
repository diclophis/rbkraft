#!/bin/sh

# makes backups and invokes overviewer

set -e

#TODO: make backup dir argument
DATE=`date +%m-%d-%Y-%H-%M-%Z`
BACKUP=/opt/backup/minecraft-world-backup-$DATE

screen -r minecraft -x -p 0 -X stuff "say $DATE\n"
sleep 1
screen -r minecraft -x -p 0 -X stuff "save-off\n"
sleep 1
screen -r minecraft -x -p 0 -X stuff "save-all\n"
sleep 2
cp -p -r /opt/minecraft/world $BACKUP
screen -r minecraft -x -p 0 -X stuff "say $DATE\n"
sleep 1
screen -r minecraft -x -p 0 -X stuff "save-on\n"

sh ~/mavencraft/scripts/overviewer.sh
