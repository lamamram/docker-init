#!/bin/bash

#### SUPPRESSIONS #######

[[ -z $(docker ps -aq --filter name="stack-php-*") ]] || docker rm -f $(docker ps -aq -f "name=stack-php-*")

#### CONTENEUR

docker run \
       --name stack-php-nginx \
       -d --restart unless-stopped \
       -p 8080:80 \
       nginx:1.27.3-bookworm-perl