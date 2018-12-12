#!/bin/bash

# makes map and invokes film

#set -e
#set -x

#if [ -e /home/minecraft/running-overviewer ];
#then
#  echo already-running-overviewer
#  exit 1
#fi

touch /home/minecraft/running-overviewer

nohup /home/minecraft/mavencraft/scripts/overviewer-run.sh $1 &

sleep 1

0<&-

exit
