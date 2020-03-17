#!/bin/bash

# makes map and invokes film

while true;
do
  if [ -e world/level.dat ];
  then
    cat scripts/normal-save.cmd | nc -w 1 localhost 25566 >/dev/null 2>&1
    inotifywait -t 30 -e CLOSE world/session.lock >/dev/null 2>&1
    mapcrafter -b -c /home/app/config/mapcrafter.conf -j 4 >/dev/null 2>&1
  else
    cat scripts/initial-save.cmd | nc -w 1 localhost 25566 >/dev/null 2>&1
    if [ -e world/session.lock ];
    then
      inotifywait -t 30 -e CLOSE world/session.lock >/dev/null 2>&1
    fi
  fi

  sleep 1
done
