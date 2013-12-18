#!/bin/sh

# makes timelapse movie

set -e

test -f locales_2.17-96_all.deb || curl -O http://ftp.us.debian.org/debian/pool/main/e/eglibc/locales_2.17-96_all.deb
test -f libc6_2.17-96_amd64.deb || curl -O http://ftp.us.debian.org/debian/pool/main/e/eglibc/libc6_2.17-96_amd64.deb
test -f phantomjs_1.9.0-1_amd64.deb || curl -O http://ftp.debian.org/debian/pool/main/p/phantomjs/phantomjs_1.9.0-1_amd64.deb

phantomjs -v || sudo dpkg -i locales_2.17-96_all.deb  libc6_2.17-96_amd64.deb phantomjs_1.9.0-1_amd64.deb
avconv -version || sudo apt-get install ffmpeg

SCREENSHOT_BASE=/mnt/minecraft-disk-2/maps/screenshots

mkdir -p $SCREENSHOT_BASE

phantomjs ~/mavencraft/scripts/screenshot.js $SCREENSHOT_BASE/latest.png

FRAMES="-i $SCREENSHOT_BASE/latest.png"

BITRATE_OPTION="-vb 4096k"
SIZE=1024x1024

avconv -y $FRAMES $BITRATE_OPTION $SCREENSHOT_BASE/current.avi

test -f $SCREENSHOT_BASE/latest.avi || cp $SCREENSHOT_BASE/current.avi $SCREENSHOT_BASE/latest.avi
cp $SCREENSHOT_BASE/latest.avi $SCREENSHOT_BASE/previous.avi

avconv -y -i concat:$SCREENSHOT_BASE/previous.avi\|$SCREENSHOT_BASE/current.avi $BITRATE_OPTION -c copy $SCREENSHOT_BASE/latest.avi

avconv -y -i $SCREENSHOT_BASE/latest.avi $BITRATE_OPTION -s $SIZE -vf 'setpts=15.0*PTS' $SCREENSHOT_BASE/latest.webm
