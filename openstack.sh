#!/bin/bash

ADMIN_PASSWORD="password"

if [[ $1 = "Debian" || $1 = "Ubuntu" ]]; then
	git clone https://git.openstack.org/openstack-dev/devstack
	sudo ./devstack/tools/create-stack-user.sh
	sudo usermod -a -G sudo stack
	sudo mv devstack /opt/stack
	su stack -c 'sudo chown -R stack:stack /opt/stack'
	mkdir /opt/stack/.cache
	sudo chown -R stack:stack /opt/stack/.cache
	sudo apt purge python3-simplejson -y
	su stack -c '/opt/stack/devstack/stack.sh'
elif [[ $1 = "Centos" ]]; then
	yum install centos-release-openstack-queens -y
	yum update
	yum install openstack-packstack -y
	packstack --allinone
fi
