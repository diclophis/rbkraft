#!/bin/sh

# makes backups and invokes overviewer

set -e

pgrep -f minecraft_server.1.7.2 > /dev/null

#TODO: make backup dir argument
BACKUP=/mnt/minecraft-disk-2/backups/minecraft-world-backup-`date +%m-%d-%Y-%H-%M`

screen -r minecraft -x -p 0 -X stuff "/say begin world save\n"
sleep 1
screen -r minecraft -x -p 0 -X stuff "/save-off\n"
sleep 1
screen -r minecraft -x -p 0 -X stuff "/save-all\n"
sleep 1
cp -p -r /home/minecraft/minecraft/world $BACKUP
screen -r minecraft -x -p 0 -X stuff "/say $BACKUP\n"
sleep 1
screen -r minecraft -x -p 0 -X stuff "/save-on\n"

#sh ~/mavencraft/scripts/overviewer.sh
