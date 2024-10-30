## on commence toujours avec une image de base
#  FROM scratch => pour les images de distrutions (ubuntu /debian / alpine ...)
FROM httpd:2.4


## métadonnée => documentation et filtrage
LABEL author="matt"
LABEL created_at="2024-10-29"
LABEL created_at.year="2024"
LABEL stack="java"
LABEL stack.service="httpd"

## envoie la conf globale de httpd dans l'image
COPY ./httpd.conf /usr/local/apache2/conf/

## on créé le dossier sites dans le dossier conf
RUN mkdir /usr/local/apache2/conf/sites

COPY ./java_app.conf /usr/local/apache2/conf/sites/


## exposer les ports surlesquels httpd devraient écouter
EXPOSE 80
# pour le https mais dans ce cas c'est FAUX => Listen 80 dans httpd.conf
EXPOSE 443


##### Lancement de l'image
## 1. ENTRYPOINT: commande non substituable par la commande du run
# => on ne peut pas utiliser run -it ... /bin/bash 
# ici bash a été ajouté à droite du entrypoint => absurde
# ENTRYPOINT [ "httpd", "-D", "FOREGROUND" ]
## 2. ENTRYPOINT + CMD: partie non substituable + partie substituable par le param. du run
# ENTRYPOINT [ "httpd" ]
# CMD ["-D", "FOREGROUND"]

## 3. CMD: totalement substituable => run -it ... /bin/bash 
CMD [ "httpd", "-D", "FOREGROUND" ]