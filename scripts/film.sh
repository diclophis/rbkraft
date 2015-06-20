#!/bin/sh

# makes timelapse movie

set -e
set -x

#test -f locales_2.17-96_all.deb || curl -O http://ftp.us.debian.org/debian/pool/main/e/eglibc/locales_2.17-96_all.deb
#test -f libc6_2.17-96_amd64.deb || curl -O http://ftp.us.debian.org/debian/pool/main/e/eglibc/libc6_2.17-96_amd64.deb
#test -f phantomjs_1.9.0-1_amd64.deb || curl -O http://ftp.debian.org/debian/pool/main/p/phantomjs/phantomjs_1.9.0-1_amd64.deb
#phantomjs -v || sudo dpkg -i locales_2.17-96_all.deb  libc6_2.17-96_amd64.deb phantomjs_1.9.0-1_amd64.deb
#avconv -version || sudo apt-get install ffmpeg

SCREENSHOT_BASE=/usr/share/nginx/html/timelapse #/mnt/minecraft-disk-2/maps/screenshots

mkdir -p $SCREENSHOT_BASE

phantomjs ~/mavencraft/scripts/screenshot.js $SCREENSHOT_BASE/latest-$3.png "http://mavencraft.net/#/24112/64/24391/-5/0/0"
#"http://mavencraft.net/#/24183/64/24504/-5/0/0" #http://mavencraft.net/current/#/$1/64/$2/-3/0/0

FRAMES="-i $SCREENSHOT_BASE/latest-$3.png"

BITRATE_OPTION="-vb 4096k"
SIZE=512x512

avconv -y $FRAMES $BITRATE_OPTION $SCREENSHOT_BASE/current-$3.avi

test -f $SCREENSHOT_BASE/latest-$3.avi || cp $SCREENSHOT_BASE/current-$3.avi $SCREENSHOT_BASE/latest-$3.avi
cp $SCREENSHOT_BASE/latest-$3.avi $SCREENSHOT_BASE/previous-$3.avi

avconv -y -i concat:$SCREENSHOT_BASE/previous-$3.avi\|$SCREENSHOT_BASE/current-$3.avi $BITRATE_OPTION -c copy $SCREENSHOT_BASE/latest-$3.avi

#avconv -y -i $SCREENSHOT_BASE/latest.avi $BITRATE_OPTION -s $SIZE -vf 'setpts=15.0*PTS' $SCREENSHOT_BASE/latest.webm
avconv -y -i $SCREENSHOT_BASE/latest-$3.avi $BITRATE_OPTION -s $SIZE -vf 'setpts=1.0*PTS' $SCREENSHOT_BASE/latest-$3.webm
