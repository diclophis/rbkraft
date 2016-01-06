ANSIBLE=ansible-playbook -c ssh -l mavencraft -i ansible/mavencraft.inventory

world:
	$(ANSIBLE) ansible/provision.yml

overviewer:
	$(ANSIBLE) -e "port=10020" ansible/toggle.yml

mavencraft:
	$(ANSIBLE) -e "port=20020" ansible/toggle.yml

light:
	$(ANSIBLE) -e "port=30020" ansible/toggle.yml

status:
	$(ANSIBLE) -e "port=20021" ansible/toggle.yml

clean:
	$(ANSIBLE) -e "port=20122" ansible/toggle.yml

destroy:
	$(ANSIBLE) -e "port=20222" ansible/toggle.yml
