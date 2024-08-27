#!/bin/bash
# backup à froid
# conteneur "one-shot" avec --rm, pas de nomn pas de redémarrage
# ici le volume nommé injecte le contenu existant
# et le bind mount fait sortir le dump
# docker run \
# --net none \
# --rm \
# -v db_data:/data \
# -v ./dump:/dump \
# alpine \
# tar -czvf /dump/dump_cold.tar.gz /data


# backup à chaud

docker run \
--rm \
--volumes-from stack-php-db \
-v ./dump:/dump \
--net stack_php \
alpine \
tar -czvf /dump/dump.tar.gz /var/lib/mysql
