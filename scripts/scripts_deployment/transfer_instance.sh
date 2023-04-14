#!/bin/bash

NUM=$1
VMIUT=/home/public/vm/bin/vmiut
IP=52
COMPLETE_IP=192.168.194.$IP
OUT=/tmp
vm_start(){ 
        if [ $($VMIUT info dataBase | grep -c running) -eq 0 ];
                then
                        $($VMIUT start dataBase > /dev/null 2>&1)
                        printf "Démarrage de la machine\n" 
                else printf "Déja démarrée\n" 
        fi

        scp -r psql user@$COMPLETE_IP:$OUT
        
        return 0
}

commandes_db(){
        printf "\t\tConnexion à  root (mdp: root) \n"
        ssh -t user@$COMPLETE_IP "su - root -c \"  mv /tmp/psql/instance_psql.sh ~/ && mv /tmp/psql/pg_hba ~/  && chmod u+x instance_psql.sh setup.sh && sh setup.sh && sh instance_psql.sh $NUM\"" 
}

scp_db(){
        scp -r psql user@$COMPLETE_IP:$OUT
}
scp_odoo(){
        IP=51
        COMPLETE_IP=192.168.194.$IP
        scp -r odoo user@$COMPLETE_IP:$OUT

}
commandes_odoo(){
        printf "\t\tConnexion à  root (mdp: root) \n"
        ssh -t user@$COMPLETE_IP "su - root -c \"  mv /tmp/odoo ~/ && docker compose -f odoo/ up -d\""

}


vm_start
scp_db
commandes_db
scp_odoo
commandes_odoo
exit 0

