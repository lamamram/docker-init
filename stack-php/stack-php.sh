#!/bin/bash

#### SUPPRESSIONS #######
# test de l'existence des conteneurs si c'est vrai je supprime les conteneurs
# -q: affiche uniquement les identifiants
[[ -z $(docker ps -aq --filter name="stack-php-") ]] || docker rm -f $(docker ps -aq -f "name=stack-php-")

docker network rm -f stack-php

#### RESEAU #####

docker network create \
       --driver=bridge \
       --subnet=172.18.0.0/24 \
       --gateway=172.18.0.1 \
       stack-php

#### CONTENEURS #######

# --env MARIADB_USER=test \
# --env MARIADB_PASSWORD=roottoor \
# --env MARIADB_DATABASE=test \
# --env MARIADB_ROOT_PASSWORD=roottoor \

docker run \
       --name stack-php-db \
       -d --restart unless-stopped \
       --env-file /vagrant/stack-php/.env \
       --net stack-php \
       -v /vagrant/stack-php/mariadb-init.sql:/docker-entrypoint-initdb.d/mariadb-init.sql:ro \
       -v db_data:/var/lib/mysql \
       mariadb:lts-ubi

docker run \
       --name stack-php-fpm \
       -d --restart unless-stopped \
       --net stack-php \
       -v /vagrant/stack-php/index.php:/srv/index.php:ro \
       bitnami/php-fpm:8.4-debian-12

# plus besoin de çà !!!
# docker cp /vagrant/stack-php/index.php stack-php-fpm:/srv/index.php


docker run \
       --name stack-php-nginx \
       -d --restart unless-stopped \
       --net stack-php \
       -p 8080:80 \
       -v /vagrant/stack-php/vhost.conf:/etc/nginx/conf.d/vhost.conf:ro \
       nginx:1.27.3-bookworm

# plus besoin de tout çà !!!
# docker cp /vagrant/stack-php/vhost.conf stack-php-nginx:/etc/nginx/conf.d/vhost.conf
# docker restart stack-php-nginx




