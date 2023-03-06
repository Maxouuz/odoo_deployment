#!/bin/bash



REMOTE=$1
PUB_KEY=$HOME/.ssh/id_rsa

copy_id(){
	printf "\tPartage de la clef publique avec la machine virtuelle:\n"
	printf "\t\tConnexion à user (mdp: user)\n" 
	ssh-copy-id -i $PUB_KEY user@$REMOTE > /dev/null 2>&1
	printf "\t\tOK\n" 
}

ssh_agent(){
	printf "\tMise en place de l'agent SSH:\n" 
	if [ -z "$SSH_AUTH_SOCK" ] ; 
	then
      		eval $(ssh-agent -s) 
      		ssh-add -T $PUB_KEY
		printf "\t\tConfiguré\n" 
	else
		printf "\t\tTourne déjà\n" 
	fi
	return 0
} 	 	

rsa_key(){
	printf "\tPrésence de la clef RSA publique : " 
	if [ -f "$PUB_KEY" ]; 
		then
			printf "OK\n" 
		else
			printf "\tGénération"
			ssh-keygen > /dev/null 2>&1
	fi
}

printf "Configuration et partage de la clef RSA-SSH:\n"
rsa_key
ssh_agent
copy_id
exit 0
