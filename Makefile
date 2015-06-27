world:
	ansible-playbook -c ssh -l mavencraft -i ansible/mavencraft.inventory ansible/provision.yml

light:
	echo | nc -w 1 mavencraft.net 20020

clean:
	echo | nc -w 1 mavencraft.net 20021

towers:
	time ruby diclophis/big_pyramid.rb draw

render:
	time ssh ubuntu@mavencraft.net sh /home/mavencraft/mavencraft/render.sh
