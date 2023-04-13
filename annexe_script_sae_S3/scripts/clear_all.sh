#!/bin/bash

VMIUT=/home/public/vm/bin/vmiut
vm_stop(){
    printf "\tArrêt de $NAME : " 
        if [ $($VMIUT info $NAME | grep -c running) -eq 0 ];
                then
                        $($VMIUT stop $NAME > /dev/null 2>&1)
                        printf "OK\n" 
                else printf "Déja stoppée\n" 
        fi
        return 0
}

vm_remove(){
    printf "\tSuppression de la VM $NAME : " 
        $($VMIUT rm $NAME > /dev/null 2>&1)
        printf "OK\n" 
 
}

vm_rm_all(){

    NAME=odoo
    vm_stop
    vm_remove
    NAME=dataBase
    vm_stop
    vm_remove
    NAME=saves
    vm_stop
    vm_remove
}
vm_rm_all
