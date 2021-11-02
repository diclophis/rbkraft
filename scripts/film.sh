#!/bin/sh

#TODO make timelapse movie of given region HQ build-out

set -e
set -x

SCREENSHOT_BASE=/usr/share/nginx/html/timelapse

mkdir -p $SCREENSHOT_BASE

phantomjs /home/app/scripts/screenshot.js $SCREENSHOT_BASE/latest-$3.png "http://${MAPCRAFTER_SERVICE_TODO}/#/24112/64/24391/-5/0/0"

FRAMES="-i $SCREENSHOT_BASE/latest-$3.png"

BITRATE_OPTION="-vb 4096k"
SIZE=512x512

avconv -y $FRAMES $BITRATE_OPTION $SCREENSHOT_BASE/current-$3.avi

test -f $SCREENSHOT_BASE/latest-$3.avi || cp $SCREENSHOT_BASE/current-$3.avi $SCREENSHOT_BASE/latest-$3.avi
cp $SCREENSHOT_BASE/latest-$3.avi $SCREENSHOT_BASE/previous-$3.avi

avconv -y -i concat:$SCREENSHOT_BASE/previous-$3.avi\|$SCREENSHOT_BASE/current-$3.avi $BITRATE_OPTION -c copy $SCREENSHOT_BASE/latest-$3.avi

avconv -y -i $SCREENSHOT_BASE/latest-$3.avi $BITRATE_OPTION -s $SIZE -vf 'setpts=1.0*PTS' $SCREENSHOT_BASE/latest-$3.webm
