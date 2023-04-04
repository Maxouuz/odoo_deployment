#!/bin/bash

VMIUT=/home/public/vm/bin/vmiut
NAME=$1
DHCP_CPT=0
DISQUE=$MODELE

if [ $# -eq 2 ];
 then 
   DISQUE=$2
fi

printf "Le disque utilisé sera : $DISQUE\n"

vm_create(){
    printf "\tCréation : " 
    
	if [ $($VMIUT lister | grep -c "\b$NAME\b") -eq 0 ];
		then 
			$($VMIUT creer -d $DISQUE $NAME > /dev/null 2>&1) 
			printf "OK\n"
		else  printf "Existe déjà\n" 
	fi
	return 0
}

vm_start(){
    printf "\tDémarrage : " 
	if [ $($VMIUT info $NAME | grep -c running) -eq 0 ];
		then
			$($VMIUT start $NAME > /dev/null 2>&1)
			printf "OK\n" 
		else printf "Déja démarrée\n" 
	fi
	return 0
}

vm_remove(){
    printf "\tSuppression de la VM : " 
	$($VMIUT rm $NAME > /dev/null 2>&1)
	printf "OK\n" 
	main
}

dhcp_ok(){
    TMP_IP=$(vm_ip)
	if [ "$TMP_IP" = "" ];
		then 
            sleep 5; 
            printf "." 
			dhcp_timeout
		else 
            printf "\n\t\tTerminé : %s\n" "$TMP_IP" 
            return 0;
	fi
}

dhcp_timeout(){
	((DHCP_CPT=DHCP_CPT+1))
	if [ $DHCP_CPT -eq 6 ];
		then 
			printf "\n\t\tTIME OUT lors de la configuration DHCP\n"
			DHCP_CPT=0
			vm_remove
		else dhcp_ok
	fi
}


dhcp_setup(){	
    printf "\tEn attente de la configuration DHCP : " 
	dhcp_ok
}

vm_ip(){
	echo $($VMIUT info $NAME | grep "ip-possible" | cut -d "=" -f 2)
}

main(){
	vm_create && vm_start && dhcp_setup
	echo $TMP_IP > /tmp/$NAME
}

printf "Création et démarrage de la VM $NAME : \n" 
main
