#!/bin/sh

ansible-playbook -c ssh -l mavencraft -i ansible/mavencraft.inventory ansible/provision.yml
