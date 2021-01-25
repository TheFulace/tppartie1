#!/bin/bash

function help() {
	echo "usage ./script_admin"
	echo 
	echo "openstack   install openstack"
	echo "git 	  intall git"
	echo "jenkins     install jenkins"
	echo "install	  install a package"
	echo "list	  list all the installed package"
	echo "useradd	  add an user"
	echo "greoupadd   add a group"
	echo "groups 	  show all the groups of an user"
	echo "status      show the status of a service"
	echo "restart     restart a service"
	echo "service     enable/disable a serivce"
	echo "help	  show this help"
}

read -p "-> " commande

os_type=`cat /etc/os-release  | head -1 | cut -f2 -d= | cut -f2 -d\"`

if [[ "$os_type" = "Ubuntu" || "$os_type" = "Debian" ]] ; then
	manager="apt-get"
elif [[ "$os_type" = "Centos" ]]; then
	manager="yum"
else
	echo "autre système"
fi

case $commande in
	"openstack")
		./openstack.sh $os_type ;;
	"git")
		sudo $manager install git
		;;
	"jenkins")
		./jenkins $os_type ;;
	"install")
		read -p "Nom du paquet: " paquet
		sudo $manager install $paquet -y
		;;
	"update")
		echo "Mise à jour du système"
		sudo $manager update -y && $manager upgrade -y
		;;
	"remove")
		read -p "Nom du paquet: " paquet
		sudo $manager remove $paquet -y
		;;
	"list")
		if [[ "$manager" = "apt-get" ]]; then
			apt list --installed
		elif [[ "$manager" = "yum" ]]; then
			yum list installed
		fi
		;;
	"useradd")
		read -p "Nom du user: " username
		adduser $username ;;
	"groupadd")
		read -p "Nom du groupe: " groupename
		addgroup $groupname ;;
	"groupes")
		read -p "Nom du user: " username
		groups $username ;;
	"status")
		read -p "Nom du service : " servicename
		systemctl status $servicename ;;
	"restart")
		read -p "Nom du service : " servicename
		systemctl restart $servicename ;;
	"service")
		read -p "Nom du service : " servicename
		read -p "On/Off : " state
		case $state in
			"on") systemctl enable $servicename ;;
			"off") systemctl disbale $servicename ;;
		esac
		;;
	"help")
		help ;;
	*)
		echo "Commande invalide"
		help ;;
esac
