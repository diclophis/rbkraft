#!/bin/sh

/home/ubuntu/mapcrafter/build/src/mapcrafter -b --logging-config /home/mavencraft/mapcrafter-log.conf -c /home/mavencraft/mapcrafter.conf -j 15 2>&1 >/dev/null | logger -t mapcrafter
echo $? | logger  -t mapcrafter
sleep 3
