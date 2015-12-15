#!/bin/sh

time sh -c "openscad -D 'msg=\"$1\"' --autocenter -o /tmp/ttt.stl text_sphere.scad && cat /tmp/ttt.stl | gzip | nc localhost 33333"
