#!/bin/sh

0<&-

pgrep "ruby"
OK_TO_RUN_UNLESS_ONE=$?

if [ $OK_TO_RUN_UNLESS_ONE = 1 ];
then
  echo no server detected
fi;

tail -n 16 /var/log/syslog
ps f -U mavencraft
df -h
free -m

sleep 1
exit
