world:
	ansible-playbook -c ssh -l mavencraft -i ansible/mavencraft.inventory ansible/provision.yml

light:
	echo | nc -v -w 30 mavencraft.net 20020

clean:
	echo | nc -v -w 15 mavencraft.net 20021
