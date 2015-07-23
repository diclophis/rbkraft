#!/bin/bash

# makes map and invokes film

#set -e
#set -x

if [ -e /home/mavencraft/running-overviewer ];
then
  echo already-running-overviewer
  exit 1
fi

touch /home/mavencraft/running-overviewer

/home/mavencraft/mavencraft/scripts/overviewer-run.sh &

sleep 1

0<&-

exit
