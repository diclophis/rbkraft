#!/bin/sh

0<&-

pgrep "ruby"
OK_TO_RUN_UNLESS_ONE=$?

if [ $OK_TO_RUN_UNLESS_ONE = 1 ];
then
  echo no server detected
fi;

journalctl -n 16 -xe

ps f -U minecraft
df -h
free -m

sleep 1
exit
