#!/bin/sh

0<&-

pgrep "ruby"
OK_TO_RUN_UNLESS_ONE=$?

if [ $OK_TO_RUN_UNLESS_ONE = 0 ];
then
  tail -n 16 /var/log/syslog
  ps f -U mavencraft
else
  echo no server detected
fi;

sleep 1
exit
