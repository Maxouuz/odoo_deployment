#!/bin/bash

VMIUT=/home/public/vm/bin/vmiut
IP=$1
NAME=$2
COMPLETE_IP=192.168.194.$IP
OUT=/tmp

vm_start(){ 
        if [ $($VMIUT info $NAME | grep -c running) -eq 0 ];
                then
                        $($VMIUT start $NAME > /dev/null 2>&1)
                        printf "Démarrage de la machine\n" 
                else printf "Déja démarrée\n" 
        fi
	
        scp -r install_docker.sh user@$COMPLETE_IP:$OUT

        return 0
}

launch_install(){
	printf "\t\tConnexion à  root (mdp: root) \n"
        ssh -t user@$COMPLETE_IP "su - root -c \" mv /tmp/install_docker.sh ~/ && chmod u+x install_docker.sh && sh install_docker.sh \"" 
}


vm_start
launch_install
exit 0
