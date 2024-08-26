#!/bin/bash

########################### SUPPRESSIONS ################################
# test de l'existence des conteneurs si c'est vrai je supprime les conteneurs
# -q: affiche uniquement les identifiants
[[ -z $(docker ps -aq --filter "name=stack_php_*") ]] || docker rm -f $(docker ps -aq -f "name=stack_php_*")

docker run \
--name stack_php_web_1 \
-d --restart unless-stopped \
-p 8080:80 \
nginx:1.27.1-alpine-slim

# en cas de -P port_number=$(docker ps -f | grep ...)