#!/bin/bash

if [ $# -ne 3 ] && [ $# -ne 2 ] ; then
    echo "Nombre invalide d'arguments : attendu <nom_vm> <id_machine>"
    exit 1
fi

if [ -z "$SSH_AUTH_SOCK" ] ; then
  exec ssh-agent bash -c "ssh-add ; $0 $1 $2"
  exit
fi

NAME=$1
IP=$2
DISQUE=$3
DIR=$(dirname "$(realpath "$0")")


printf "Création et configuration de la VM %s (192.168.194.%s)\n" "$NAME" "$IP" 

$DIR/create_vm.sh $NAME $DISQUE
TMP_IP=$(cat /tmp/$NAME)
$DIR/ssh_config_rsa.sh $TMP_IP
$DIR/config_vm.sh $NAME $TMP_IP $IP
