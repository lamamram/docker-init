########################### SUPPRESSIONS ################################
# test de l'existence des conteneurs si c'est vrai je supprime les conteneurs
# -q: affiche uniquement les identifiants
[[ -z $(docker ps -aq --filter "name=stack-php-*") ]] || docker rm -f $(docker ps -aq -f "name=stack-php-*")
 
 
docker network ls | grep stack-php
if [ $? -eq 0 ]; then
    docker network rm stack-php
fi
 
############################ RESEAU ###################################


docker network create \
       --driver=bridge \
       --subnet=172.18.0.0/16 \
       --gateway=172.18.0.1 \
       stack-php

############################ CONTENEURS ###################################


## mécanisme d'entrypoint
# 1. inspecter l'image / conteneur : pour regarder la clé "Entrypoint" et voir ...entrypoint.sh
# 2. regarder la doc de l'image s'il existe ou trouver le dossier où on peut monter les configs
# 3. on fait un volume "bind mount" 

## masquer les secrets !!
# 1. on laisse les options -e ou --env avec des valeurs chiffrées avec par ex. Vault
# 2. on charge un fichier d'environnement .env

## rendre les points de montage eb lecture seule !! (faille potentielle)
# 1. ajouter :ro dans le bind mount 
docker run \
       --name stack-php-db \
       --restart unless-stopped -d \
       --net stack-php \
       --env-file .env \
       -v ./mariadb-init.sql:/docker-entrypoint-initdb.d/mariadb-init.sql:ro \
       -v db_data:/var/lib/mysql \
       mariadb:lts

# -e MARIADB_USER=test \
# -e MARIADB_PASSWORD=roottoor \
# -e MARIADB_DATABASE=test \
# -e MARIADB_ROOT_PASSWORD=roottoor \


## -v bind mount:
# 1. à gauche du bind mount on doit avoir un chemin explicite sinon => volumne nommé
# 2. à gauche et à droite même nature fichier:fichier ou dossier:dossier
docker run \
       --name stack-php-8.3 \
       --restart unless-stopped -d \
       --net stack-php \
       -v ./index.php:/srv/index.php:ro \
       bitnami/php-fpm:8.3-debian-12

# docker cp index.php stack-php-8.3:/srv/index.php



docker run \
       --name stack-php-nginx \
       --restart unless-stopped -d \
       --net stack-php \
       -p 192.168.1.30:8080:80 \
       -v ./vhost.conf:/etc/nginx/conf.d/vhost.conf:ro \
       nginx:1.27.2-bookworm

# plus besoin de çà !!
# docker cp vhost.conf stack-php-nginx:/etc/nginx/conf.d/vhost.conf
# docker restart stack-php-nginx