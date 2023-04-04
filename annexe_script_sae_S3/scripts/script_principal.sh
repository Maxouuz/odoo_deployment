#!/bin/bash

NAME='odoo'

creation(){
   printf "premiere config\n"
   sh create_config.sh $NAME 51 /home/public/vm/disque-bullseye-11.6-10go.vdi
   restart
   
    sh transfer_docker.sh 51 $NAME
#   NAME='dataBase'
 #  sh create_config.sh $NAME 52 /home/public/vm/disque-bullseye-11.6-10go.vdi
 #  restart
   #ssh -t user@192.168.194.52 "su - root -c \" apt install postgresql \"" 
#   NAME="traefik"
#   sh create_config.sh $NAME 53
#   restart
#   NAME='saves'
#   sh create_config.sh $NAME 54
#   restart
}

restart(){
   vmiut stop $NAME
   sleep 5
   vmiut start $NAME
   sleep 40
}
creation
