#!/bin/bash

NUM=$1

creer_user(){
   #if pour vérifier si l'utilisateur existe
   su postgres -c "createuser -d odoo$NUM --pwprompt"
}

creer_base(){
   #if pour voir si la base existe déjà
   su postgres -c "createdb --encoding=UTF-8 --owner=odoo odoodb$NUM"
}
pghba(){
   cat pg_hba >> /etc/postgresql/13/main/pg_hba.conf #ne pas oublier de transferer le fichier pg_hba
}

creer_user
creer_base
pghba
exit 0
