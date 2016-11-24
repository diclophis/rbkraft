#!/usr/bin/env ruby

[
  "sh /home/minecraft/mavencraft/scripts/overviewer.sh 12"
  "sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft.sh 5000M mavencraft 25564 25566",
  "sh /home/minecraft/mavencraft/ansible/roles/minecraft/files/minecraft.sh 5000M minecraft 25565 25567"
].collect { |command|
    puts ["sudo", "-u", "minecraft", *command.split].join(" ")
}

#   /usr/bin/minecraft-status.sh
#   /usr/bin/minecraft-repair.sh kill
#   /usr/bin/minecraft-repair.sh destroy
#   ruby /home/minecraft/voxelize-stl-xinetd/accept-std-to-tempfile.rb
