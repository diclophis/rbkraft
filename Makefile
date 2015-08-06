world:
	ansible-playbook -c ssh -l mavencraft -i ansible/mavencraft.inventory ansible/provision.yml

overviewer:
	echo | nc -w 1 mavencraft.net 10020

mavencraft:
	echo | nc -w 1 mavencraft.net 20020

light:
	echo | nc -w 1 mavencraft.net 30020

status:
	echo | nc -w 1 mavencraft.net 20021

clean:
	echo kill | nc -w 1 mavencraft.net 20022

destroy:
	echo destroy | nc -w 1 mavencraft.net 20022

towers:
	time ruby diclophis/big_pyramid.rb draw

render:
	ssh ubuntu@mavencraft.net sudo mkdir -p /usr/share/nginx/html/scenes
	ssh ubuntu@mavencraft.net sudo chown  www-data:ubuntu /usr/share/nginx/html/scenes
	ssh ubuntu@mavencraft.net sudo chmod g+w /usr/share/nginx/html/scenes
	scp TowerScene.json ubuntu@mavencraft.net:/tmp/TowerScene-raw.json
	scp render.sh ubuntu@mavencraft.net:/tmp/render.sh
	scp render.rb ubuntu@mavencraft.net:/tmp/render.rb
	ssh ubuntu@mavencraft.net sh /tmp/render.sh
