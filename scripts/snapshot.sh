#!/bin/sh

set -e

sh /home/minecraft/mavencraft/scripts/backup.sh
sh /home/minecraft/mavencraft/scripts/overviewer.sh
sh /home/minecraft/mavencraft/scripts/film.sh 10050 -50 circletower2


cd ~/
ruby rmolder.rb "/mnt/minecraft-disk-2/backups/minecraft*"

echo "trap"
sleep 5
