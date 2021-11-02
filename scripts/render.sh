#!/bin/sh

#TODO: build out chunky ray trace rendering pipeline
#TODO: update to latest version: https://chunky.llbit.se/
#TODO: build timeline based on backup pipeline
set -x
set -e

WIDTH=320
HEIGHT=240
SPP=1024 #8192
THREADS=40


sudo rm -Rf /usr/share/nginx/html/scenes
sudo mkdir -p /usr/share/nginx/html/scenes
sudo chown  www-data:ubuntu /usr/share/nginx/html/scenes
sudo chmod 777 /usr/share/nginx/html/scenes

SCREENSHOT_BASE=/usr/share/nginx/html/timelapse
sudo rm -Rf $SCREENSHOT_BASE
sudo mkdir -p $SCREENSHOT_BASE
sudo chown  www-data:ubuntu $SCREENSHOT_BASE
sudo chmod g+w $SCREENSHOT_BASE

for I in $(seq 1 128)
do

cat /home/app/scripts/initial-save.cmd | nc -w 1 localhost 25566 2>&1 > /dev/null
cat /home/app/scripts/initial-save.cmd | nc -w 1 localhost 25567 2>&1 > /dev/null
sleep 1

rm -f /usr/share/nginx/html/scenes/*.dump*
rm -f /usr/share/nginx/html/scenes/*.octree*
rm -f /usr/share/nginx/html/scenes/*.grass*
rm -f /usr/share/nginx/html/scenes/*.foliage*
rm -f /usr/share/nginx/html/scenes/*.png

	cat /tmp/TowerScene-raw.json | ruby /tmp/render.rb $I $SPP $WIDTH $HEIGHT > /tmp/TowerScene.json
	mv /tmp/TowerScene.json /usr/share/nginx/html/scenes/TowerScene.json

  java -jar ~/ChunkyLauncher.jar -scene-dir /usr/share/nginx/html/scenes -render TowerScene -threads $THREADS

  mv /usr/share/nginx/html/scenes/TowerScene-$SPP.png $SCREENSHOT_BASE/latest-$I.png

  FRAMES="-i $SCREENSHOT_BASE/latest-$I.png"

  BITRATE_OPTION="-vb 4096k"
  SIZE="${WIDTH}x${HEIGHT}"

  avconv -y $FRAMES $BITRATE_OPTION $SCREENSHOT_BASE/current.avi

  test -f $SCREENSHOT_BASE/latest.avi || cp $SCREENSHOT_BASE/current.avi $SCREENSHOT_BASE/latest.avi
  cp $SCREENSHOT_BASE/latest.avi $SCREENSHOT_BASE/previous.avi

  avconv -y -i concat:$SCREENSHOT_BASE/previous.avi\|$SCREENSHOT_BASE/current.avi $BITRATE_OPTION -c copy $SCREENSHOT_BASE/latest.avi

  avconv -y -i $SCREENSHOT_BASE/latest.avi $BITRATE_OPTION -s $SIZE -vf 'setpts=1.0*PTS' $SCREENSHOT_BASE/latest.webm
done
