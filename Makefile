world:
	ansible-playbook -c ssh -l mavencraft -i ansible/mavencraft.inventory ansible/provision.yml

light:
	echo | nc -w 1 mavencraft.net 20020

status:
	echo | nc -w 1 mavencraft.net 20021

clean:
	echo kill | nc -w 1 mavencraft.net 20022

towers:
	time ruby diclophis/big_pyramid.rb draw

render:
	ssh ubuntu@mavencraft.net sudo mkdir -p /usr/share/nginx/html/scenes
	ssh ubuntu@mavencraft.net sudo chown  www-data:ubuntu /usr/share/nginx/html/scenes
	ssh ubuntu@mavencraft.net sudo chmod g+w /usr/share/nginx/html/scenes
	rsync render.sh ubuntu@mavencraft.net:/usr/share/nginx/html/scenes
	cat TowerScene.json | ruby render.rb > /tmp/TowerScene.json
	rsync /tmp/TowerScene.json ubuntu@mavencraft.net:/usr/share/nginx/html/scenes
	ssh ubuntu@mavencraft.net sh /usr/share/nginx/html/scenes/render.sh
