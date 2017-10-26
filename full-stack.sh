#!bin/sh


sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft-repair.sh kill
sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft-repair.sh destroy

rm -Rf /home/minecraft/html/*

sh /home/minecraft/mavencraft/scripts/overviewer.sh 8
sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft.sh 1000M mavencraft 25564 25566
# /usr/bin/minecraft.sh 1000M minecraft 25565 25567

sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft-status.sh
