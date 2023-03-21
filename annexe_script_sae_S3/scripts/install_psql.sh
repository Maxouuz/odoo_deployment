#!/bin/bash

installpsql(){
apt-get update
apt-get install postgresql
su postgres -c "createuser odoo --pwprompt"
su postgres -c "createdb --encoding=UTF-8 --owner=odoo odoodb1"
sed -i "s/#listen_addresses = 'localhost'/listen_addresses ='0.0.0.0'/g" /etc/postgresql/13/main/postgresql.conf
cat pg_hba >> /etc/postgresql/13/main/pg_hba.conf #ne pas oublier de transferer le fichier pg_hba
}


installpsql






