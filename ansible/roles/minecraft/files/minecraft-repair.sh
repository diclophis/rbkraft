#!/bin/sh

#nc -l 0.0.0.0 20023

echo minecraft-repair

rm -Rf /home/mavencraft/world*
rm -Rf /usr/share/nginx/html/normal
rm -Rf /usr/share/nginx/html/scenes

rm -Rf /home/mavencraft/running

pkill -9 -f overviewer || true
pkill -9 -f java || true
pkill -9 -f java || true
pkill -9 -f ruby || true

sleep 1
#reboot
