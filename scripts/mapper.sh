#!/bin/sh

set -x
set -e

mapcrafter $2 -b -c /home/minecraft/mapcrafter.conf -j $1 2>&1

#>/dev/null | logger -t mapcrafter
#echo $? | logger  -t mapcrafter
