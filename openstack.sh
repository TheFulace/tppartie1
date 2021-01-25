#!/bin/bash


if [[ $1 = "Debian" || $1 = "Ubuntu" ]]; then
	sudo apt-get update -y && sudo apt-get upgrade -y
	git clone https://git.openstack.org/openstack-dev/devstack -b stable/queens
	sudo ./devstack/tools/create-stack-user.sh
	sudo usermod -a -G sudo stack
	sudo mv devstack /opt/stack
	su stack -c 'sudo chown -R stack:stack /opt/stack'
	mkdir /opt/stack/.cache
	sudo chown -R stack:stack /opt/stack/.cache
	sudo apt purge python3-simplejson -y
	sudo apt-get purge mysql-server -y
	sudo apt-get purge mysql* -y
	sudo rm -rf /var/lib/mysql/ /etc/mysql/
	su stack -c './openstack_ubuntu'
elif [[ $1 = "Centos" ]]; then
	yum install centos-release-openstack-queens -y
	yum update
	yum install openstack-packstack -y
	packstack --allinone
fi
