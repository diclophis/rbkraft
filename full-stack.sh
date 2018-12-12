#!bin/sh


#TODO: figure out repair/destroy case for in kube
#sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft-repair.sh kill
#sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft-repair.sh destroy
#rm -Rf /home/minecraft/html/*

#sh /home/minecraft/mavencraft/scripts/overviewer.sh 8 &

#java -Dlog4j.configurationFile=log4j2.xml -d64 -XX:UseSSE=2 -Xmx10000M -Xms10000M -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:ParallelGCThreads=32 -XX:+AggressiveOpts -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -server -jar /home/minecraft/minecraft.jar --port 25564 nogui

sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft.sh 10000M mavencraft 25564 25566

#sleep 5

#echo ~/Downloads/linear_extrude-002.stl | sh voxelize-stl-xinetd/process-one-stl.sh 300 0 42 160 lapis_block &
#echo ~/Downloads/RubyModel/ruby-004.stl | sh voxelize-stl-xinetd/process-one-stl.sh 199 0 32 0 bedrock &

#sh mavencraft/scripts/text.sh &

#cd mavencraft && ruby diclophis/explore-world.rb

#kill -- -$PGID

#wait

# /usr/bin/minecraft.sh 1000M minecraft 25565 25567

#sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft-status.sh
