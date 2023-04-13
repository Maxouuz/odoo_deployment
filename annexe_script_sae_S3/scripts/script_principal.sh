#!/bin/bash

NAME='odoo'
IP=51
creation(){
   printf "premiere config\n"
   ./create_config.sh $NAME $IP /home/public/vm/disque-bullseye-11.6-10go.vdi
   restart
#   ssh-keygen -R "192.168.194.IP" > /dev/null
   sh transfer_docker.sh $IP $NAME
   IP=52
   NAME='dataBase'
   ./create_config.sh $NAME $IP /home/public/vm/disque-bullseye-11.6-10go.vdi
   restart
#   ssh-keygen -R "192.168.194.$IP" > /dev/null
   ./transfer_psql.sh $IP $NAME
    IP=53
 #  NAME='saves'
 #  ./create_config.sh $NAME $IP
 #  restart
}

restart(){
   vmiut stop $NAME
   sleep 5
   vmiut start $NAME
   sleep 40
   ssh -q user@192.168.194.$IP echo "La machine fonctionne" || restart
}
creation
