#!/bin/sh

mapcrafter -b --logging-config /home/minecraft/mapcrafter-log.conf -c /home/minecraft/mapcrafter.conf -j 6 2>&1 >/dev/null | logger -t mapcrafter
echo $? | logger  -t mapcrafter
sleep 3
