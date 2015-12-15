#!/bin/sh

/home/ubuntu/mapcrafter/build/src/mapcrafter -b --logging-config /home/ubuntu/mapcrafter/build/mapcrafter-log.conf -c /home/ubuntu/mapcrafter/build/mapcrafter.conf -j 16 2>&1 >/dev/null | logger -t mapcrafter
