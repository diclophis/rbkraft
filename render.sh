#!/bin/sh

set -x

SPP=8

sudo mkdir -p /usr/share/nginx/html/scenes
sudo chown  www-data:ubuntu /usr/share/nginx/html/scenes
sudo chmod g+w /usr/share/nginx/html/scenes

#cat /tmpTowerScene.json | ruby render.rb > /tmp/TowerScene.json
#scp /tmp/TowerScene.json ubuntu@mavencraft.net:/usr/share/nginx/html/scenes/TowerScene.json

sudo mkdir -p /usr/share/nginx/html/scenes
sudo chown  www-data:ubuntu /usr/share/nginx/html/scenes
sudo chmod 777 /usr/share/nginx/html/scenes

#sudo cp -Rv ~/.chunky/scenes /usr/share/nginx/html/
#sudo chown -Rv www-data:www-data /usr/share/nginx/html/scenes

SCREENSHOT_BASE=/usr/share/nginx/html/timelapse #/mnt/minecraft-disk-2/maps/screenshots
sudo rm -Rf $SCREENSHOT_BASE

sudo mkdir -p $SCREENSHOT_BASE
sudo chown  www-data:ubuntu $SCREENSHOT_BASE
sudo chmod g+w $SCREENSHOT_BASE


for I in $(seq 1 32)
do

rm -f /usr/share/nginx/html/scenes/*.dump*
rm -f /usr/share/nginx/html/scenes/*.octree*

#sudo rm -Rf /usr/share/nginx/html/scenes
#rm -f ~/.chunky/scenes/*.octree*
#rm -f ~/.chunky/scenes/*.grass*
#rm -f ~/.chunky/scenes/*.foilage*
#rm -f ~/.chunky/scenes/flowers*
rm -f /usr/share/nginx/html/scenes/*.grass*
rm -f /usr/share/nginx/html/scenes/*.foliage*
rm -f /usr/share/nginx/html/scenes/*.png
##java -jar ~/ChunkyLauncher.jar -reset flowers TowerScene

	cat /tmp/TowerScene-raw.json | ruby /tmp/render.rb $I $SPP > /tmp/TowerScene.json
	mv /tmp/TowerScene.json /usr/share/nginx/html/scenes/TowerScene.json

  java -jar ~/ChunkyLauncher.jar -threads 10 -scene-dir /usr/share/nginx/html/scenes -render TowerScene

  mv /usr/share/nginx/html/scenes/TowerScene-$SPP.png $SCREENSHOT_BASE/latest-$I.png

  FRAMES="-i $SCREENSHOT_BASE/latest-$I.png"

  BITRATE_OPTION="-vb 4096k"
  SIZE=640x480

  avconv -y $FRAMES $BITRATE_OPTION $SCREENSHOT_BASE/current.avi

  test -f $SCREENSHOT_BASE/latest.avi || cp $SCREENSHOT_BASE/current.avi $SCREENSHOT_BASE/latest.avi
  cp $SCREENSHOT_BASE/latest.avi $SCREENSHOT_BASE/previous.avi

  avconv -y -i concat:$SCREENSHOT_BASE/previous.avi\|$SCREENSHOT_BASE/current.avi $BITRATE_OPTION -c copy $SCREENSHOT_BASE/latest.avi

  #avconv -y -i $SCREENSHOT_BASE/latest.avi $BITRATE_OPTION -s $SIZE -vf 'setpts=15.0*PTS' $SCREENSHOT_BASE/latest.webm
  avconv -y -i $SCREENSHOT_BASE/latest.avi $BITRATE_OPTION -s $SIZE -vf 'setpts=1.0*PTS' $SCREENSHOT_BASE/latest.webm
done
