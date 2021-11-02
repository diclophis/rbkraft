#!/bin/sh

#TODO: make backup dir argument
#TODO: repair and build out backup/restore tech
#TODO: repair service hostname for minecraft api endpoint
# makes backups and invokes overviewer

set -e

DATE=`date +%m-%d-%Y-%H-%M-%Z`
BACKUP=/home/minecraft/backup/minecraft-world-backup-$DATE

echo "authentic\nsave-off\n" | nc rbkraft-service 25566
echo "authentic\nsave-all\n" | nc rbkraft-service 25566

cp -p -r /home/minecraft/world $BACKUP

echo "authentic\nsave-on\n" | nc rbkraft-service 25566
echo "authentic\nsay $DATE\n" | nc rbkraft-service 25566

find /home/minecraft/backup -maxdepth 1 -type d -ctime +1 | xargs rm -rf
