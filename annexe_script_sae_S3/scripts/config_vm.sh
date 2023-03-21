#!/bin/bash

DIR=$(dirname "$(realpath "$0")")

NAME=$1
TMP=$2
ID=$3
IP="192.168.194.$ID"
OUT=/tmp
REPO=to_transfer
SRC=$DIR/$REPO
DEST=$OUT/$REPO

transfer(){
	printf "\tTransfert par SCP :\n" 
	scp -r $SRC user@$TMP:$OUT
	printf "\t\tOK\n" 
}

config(){
	printf "\tExécution du script:\n" 
	printf "\t\tConnexion à  root (mdp: root) \n"
	ssh -t user@$TMP "su - root -c \"sh $DEST/config.sh $NAME $ID\""
	printf "\n\t\tConfiguration terminée\n" 
}

sudo_utilities(){
	printf "\tInstallation de sudo et d'utilitaires:\n" 
	printf "\t\tConnexion à  root (mdp: root) \n"
	ssh -t user@$TMP "su - root -c \"apt-get install -y --fix-missing sudo vim less tree rsync curl && usermod user -G sudo && systemctl reboot\""
	printf "\n\t\tInstallation terminée\n" 
}


printf "Exécution du script de configuration\n" 
transfer
config
sudo_utilities
printf "\tRedémarrage de $NAME\n" 
