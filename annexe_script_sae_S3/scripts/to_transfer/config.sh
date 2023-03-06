#!/bin/bash

DIR=$(dirname "$(realpath "$0")")
NAME=$1
IP=$2

rename(){
    printf "\tRenommage de la VM en %s" "$NAME :" 
    echo $NAME > /etc/hostname
    sed -i "s/debian/$NAME/g" /etc/hosts
    printf "OK\n" 
}

dns(){
    printf "\tConfiguration du DNS local:" 
    cat $DIR/hosts >> /etc/hosts
    printf "OK\n" 
}

interfaces(){    
    printf "\tIP statique et Passerelle:" 
    local FILE=/etc/network/interfaces
    cat $DIR/interfaces | sed -r "s/@/$IP/g" > $FILE

    printf "OK\n" 
}

proxy(){
    printf "\tConfiguration du proxy:" 
    cat $DIR/environment >> /etc/environment
    . /etc/environment
    printf "OK\n" 
}

ntp(){
    printf "\tConfiguration du NTP:" 
    local NTP="ntp.univ-lille.fr"
    local FILE=/etc/systemd/timesyncd.conf
    local SERVICE=systemd-timesyncd

    sed -i "s/#NTP=/NTP=$NTP/g" "$FILE"
    systemctl restart $SERVICE.service 
    printf "OK\n" 
}


update(){
	printf "\tMise à jour de la VM:" 
	apt-get update > /dev/null 2>&1
	apt-get full-upgrade -y > /dev/null 2>&1 && printf "OK\n" || printf "NOK\n" 
}

utilitaires(){
	printf "\tInstallation d'utilitaires:" 
    . /etc/environment
	apt-get update > /dev/null 2>&1
	apt-get install -y --fix-missing vim less tree rsync curl
    printf "OK\n" 
}

sudo(){
	printf "\tConfiguration de SUDO:\n" 
    printf "\t\tInstallation:" 
    . /etc/environment
	apt-get update > /dev/null 2>&1
	apt-get install sudo -y --fix-missing
    printf "OK\n" 
    printf "\t\tAjout d'user à sudo:" 
	usermod user -G sudo
    printf "OK\n" 
}


printf "%s\n" "-----------------------" 
printf "SCRIPT DE CONFIGURATION\n" 
rename
dns
interfaces
proxy
ntp
update
# sudo
# utilitaires
printf "FIN\n" 
printf "%s\n" "-----------------------" 
