#!/bin/bash

#creer une instance : script + numéro_user + num_port
NUMUSER=$1
NUMPORT=$2
modification_fichiers(){
    printf "modification de odoo.conf\n" 
    sed -i "s/db_name = odoodb\S*/db_name = odoodb$NUMUSER/g" ./odoo/config/odoo.conf 
    printf "modification de docker-compose.yml\n" 
    sed -i 's/odoo\([0-9][0-9]*\)/odoo'"$NUMUSER"'/g' ./odoo/docker-compose.yml 
    sed -i    's/80\([0-9][0-9]*\)/'"$NUMPORT"'/g' ./odoo/docker-compose.yml
    printf "modification de pg_hba"
    sed -i 's/odoo\([0-9][0-9]*\)/odoo'"$NUMUSER"'/g' ./psql/pg_hba
}

transfere_fichiers(){

   ./transfer_instance.sh 1

}


modification_fichiers
transfere_fichiers
