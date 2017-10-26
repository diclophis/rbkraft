#!/bin/sh

set -x

line=$1
echo "minecraft-repair: $line" | logger -t minecraft-repair-$line

if [ "$line" = "destroy" ];
then
  echo destroying

  echo -e 'authentic\nsave-on\nsave-all' | nc -w 1 localhost 25566 2>&1 > /dev/null
  echo -e 'authentic\nsave-on\nsave-all' | nc -w 1 localhost 25567 2>&1 > /dev/null
  echo -e 'authentic\nsave-on\nsave-all' | nc -w 1 localhost 25566 2>&1 > /dev/null
  echo -e 'authentic\nsave-on\nsave-all' | nc -w 1 localhost 25567 2>&1 > /dev/null

  pkill -9 -f overviewer || true
  pkill -9 -f mapcrafter || true
  pkill -9 -f 'java(.*)mavencraft-' || true
  pkill -9 -f 'server2(.*)mavencraft-' || true

  rm -Rf /home/minecraft/mavencraft-world

  line="kill"
fi;

if [ "$line" = "kill" ];
then
  echo killing

  echo -e 'authentic\nsave-on\nsave-all' | nc -w 1 localhost 25566 2>&1 > /dev/null
  echo -e 'authentic\nsave-on\nsave-all' | nc -w 1 localhost 25567 2>&1 > /dev/null
  echo -e 'authentic\nsave-on\nsave-all' | nc -w 1 localhost 25566 2>&1 > /dev/null
  echo -e 'authentic\nsave-on\nsave-all' | nc -w 1 localhost 25567 2>&1 > /dev/null

  #pkill -9 -f overviewer || true
  #pkill -9 -f mapcrafter || true

  pkill -9 -f 'java(.*)mavencraft-' || true
  pkill -9 -f 'server2(.*)mavencraft-' || true

  rm -Rf /home/minecraft/running-mavencraft
  rm -Rf /home/minecraft/running-overviewer
fi;
