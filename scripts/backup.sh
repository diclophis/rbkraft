#!/bin/sh

# makes backups and invokes overviewer

set -e

#TODO: make backup dir argument
DATE=`date +%m-%d-%Y-%H-%M-%Z`
BACKUP=/opt/backup/minecraft-world-backup-$DATE
MAVENCRAFT="| nc mavencraft.net 25566"
#screen -r minecraft -x -p 0 -X stuff "say $DATE\n"
#sleep 1
echo "authentic\nsave-off\n" | nc mavencraft.net 25566
echo "authentic\nsave-all\n" | nc mavencraft.net 25566
cp -p -r /opt/minecraft/world $BACKUP

echo "authentic\nsave-on\n" | nc mavencraft.net 25566
echo "authentic\nsay $DATE\n" | nc mavencraft.net 25566

#screen -r minecraft -x -p 0 -X stuff "save-off\n"
#sleep 1
#screen -r minecraft -x -p 0 -X stuff "save-all\n"
#sleep 2
#screen -r minecraft -x -p 0 -X stuff "say $DATE\n"
#sleep 1
#screen -r minecraft -x -p 0 -X stuff "save-on\n"
#sh ~/mavencraft/scripts/overviewer.sh

find /opt/backup -maxdepth 1 -type d -ctime +1 | xargs rm -rf
