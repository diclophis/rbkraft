#!/bin/sh

#sudo rm -Rf /usr/share/nginx/html/scenes
rm -f /usr/share/nginx/html/scenes/*.dump*
rm -f /usr/share/nginx/html/scenes/*.octree*
#rm -f ~/.chunky/scenes/*.octree*  
#rm -f ~/.chunky/scenes/*.grass*  
#rm -f ~/.chunky/scenes/*.foilage*  
#rm -f ~/.chunky/scenes/flowers*
#rm -f ~/.chunky/scenes/*.png
##java -jar ~/ChunkyLauncher.jar -reset flowers TowerScene
sudo mkdir -p /usr/share/nginx/html/scenes
sudo chown  www-data:www-data /usr/share/nginx/html/scenes
sudo chmod 777 /usr/share/nginx/html/scenes
java -jar ~/ChunkyLauncher.jar -threads 16 -scene-dir /usr/share/nginx/html/scenes -render TowerScene
#sudo cp -Rv ~/.chunky/scenes /usr/share/nginx/html/
#sudo chown -Rv www-data:www-data /usr/share/nginx/html/scenes
