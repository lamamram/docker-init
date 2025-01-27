#!/bin/bash

#### SUPPRESSIONS #######
# test de l'existence des conteneurs si c'est vrai je supprime les conteneurs
# -q: affiche uniquement les identifiants
[[ -z $(docker ps -aq --filter name="stack-php-") ]] || docker rm -f $(docker ps -aq -f "name=stack-php-")


#### CONTENEURS #######

docker run \
       --name stack-php-nginx \
       -d --restart unless-stopped \
       -p 8080:80 \
       nginx:1.27.3-bookworm

docker run \
       --name stack-php-fpm \
       -d --restart unless-stopped \
       bitnami/php-fpm:8.4-debian-12

