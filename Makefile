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
	cat TowerScene.json | ruby render.rb > /tmp/TowerScene.json
	scp render.sh ubuntu@mavencraft.net:/tmp/render.sh
	scp /tmp/TowerScene.json ubuntu@mavencraft.net:/usr/share/nginx/html/scenes/TowerScene.json
	ssh ubuntu@mavencraft.net sh /tmp/render.sh
