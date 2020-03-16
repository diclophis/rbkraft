#!/bin/sh

set -e

mapcrafter $2 -b -c /home/app/config/mapcrafter.conf -j $1 2>&1 > /dev/null
