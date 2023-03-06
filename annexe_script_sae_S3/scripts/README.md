# Script de création de VM sommairement configurées

Projet annexe non essentiel permettant de configurer de créer et configurer des VM nommées avec un identifiant machine défini sur le réseau.

## Exécution
```bash
./create_config.sh <nom_vm> <id_machine>
```

## Déroulé
 1. Le script principal (./create_config.sh) crée une VM nommée
 2. Un script de configuration lui est transmis ainsi qu'un dossier avec des fichiers de configuration
 3. Le script de configuration s'execute (proxy, dns, interface, màj, ...) 
 4. Redémarrage de la VM