#!/bin/bash


creation(){
   printf "premiere config\n"
   sh create_config.sh odoo 51 /home/public/vm/disque-bullseye-11.6-10go.vdi
   sh transfer_docker.sh 51 odoo
   sh create_config.sh dataBase 52
   sh create_config.sh traefik 53
   sh create_config.sh saves 54

}
creation
