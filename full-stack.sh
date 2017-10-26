#!bin/sh


sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft-repair.sh kill
sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft-repair.sh destroy

rm -Rf /home/minecraft/html/*

sh /home/minecraft/mavencraft/scripts/overviewer.sh 8 &

sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft.sh 1000M mavencraft 25564 25566 &

sleep 5

echo ~/Downloads/linear_extrude-002.stl | sh voxelize-stl-xinetd/process-one-stl.sh 300 0 42 160 lapis_block &
echo ~/Downloads/RubyModel/ruby-004.stl | sh voxelize-stl-xinetd/process-one-stl.sh 199 0 32 0 bedrock &
sh mavencraft/scripts/text.sh &

cd mavencraft && ruby diclophis/explore-world.rb

#kill -- -$PGID

wait

# /usr/bin/minecraft.sh 1000M minecraft 25565 25567


#sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft-status.sh
