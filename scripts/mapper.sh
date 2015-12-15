#!/bin/sh

/home/ubuntu/mapcrafter/build/src/mapcrafter -b --logging-config /home/mavencraft/mapcrafter-log.conf -c /home/mavencraft/mapcrafter.conf -j 4 2>&1 >/dev/null | logger -t mapcrafter
