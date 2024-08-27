#!/bin/bash

########################### SUPPRESSIONS ################################
# test de l'existence des conteneurs si c'est vrai je supprime les conteneurs
# -q: affiche uniquement les identifiants
[[ -z $(docker ps -aq --filter "name=stack-php-*") ]] || docker rm -f $(docker ps -aq -f "name=stack-php-*")

docker network ls | grep stack_php
if [ $? -eq 0 ]; then
    docker network rm stack_php
fi

docker volume ls | grep nfs-vol
if [ $? -eq 0 ]; then
    docker volume rm nfs-vol
fi

############################ RESEAU ######################################

docker network create \
       --subnet=172.18.0.0/24 \
       --gateway=172.18.0.1 \
       stack_php

############################ VOLUMES #####################################

docker volume create \
       --driver local \
       --opt type=nfs \
       --opt o=addr=192.168.1.30,ro \
       --opt device=:/mnt/nfs-dir \
       nfs-vol

############################ CONTAINERS ###################################
docker run \
--name stack-php-db \
-d --restart unless-stopped \
--net stack_php \
--env-file .env \
-v ./mariadb-init.sql:/docker-entrypoint-initdb.d/mariadb-init.sql:ro \
-v db_data:/var/lib/mysql \
mariadb:11.5

# --env MARIADB_USER=test \
# --env MARIADB_PASSWORD=roottoor \
# --env MARIADB_DATABASE=test \
# --env MARIADB_ROOT_PASSWORD=roottoor \


docker run \
--name stack-php-php8.2 \
-d --restart unless-stopped \
--env-file .env \
--net stack_php \
-v nfs-vol:/srv \
-v ./www.conf:/opt/bitnami/php/etc/php-fpm.d/www.conf:ro \
bitnami/php-fpm:8.2-debian-12

# --mount src=,dst=/srv,volume-driver=local,volume-opt=type=nfs,volume-opt=o=addr=192.168.1.30,volume-opt=device=:/mnt/nfs-dir \
#-v ./index.php:/srv/index.php:ro \
# docker cp index.php stack-php-php8.2:/srv/index.php
# --env-file .env \
# -v ./php-fpm.conf:/php-fpm.conf:ro \

docker run \
--name stack-php-web \
-d --restart unless-stopped \
-p 8080:80 \
--net stack_php \
-v ./vhost.conf:/etc/nginx/conf.d/vhost.conf:ro \
nginx:1.27.1-alpine-slim
# --link dns_php:stack_php_php8.2 (DEPECATED alias dns pour docker0)

# docker cp vhost.conf stack-php-web:/etc/nginx/conf.d/vhost.conf
# docker restart stack-php-web
# en cas de -P port_number=$(docker ps -f | grep ...)