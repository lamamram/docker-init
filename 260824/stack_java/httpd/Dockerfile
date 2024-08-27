# image de base image publique OU privée (registry) ou scratch (rien pour ditrub ou application en binaire)
FROM httpd:2.4

LABEL author="mlamamra"
LABEL created_at="2024-08-27"
LABEL created_at.year="2024"
LABEL stack="java"
LABEL stack.item="httpd"

# ajout de la conf en local dans l'image
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

RUN mkdir /usr/local/apache2/conf/sites


EXPOSE 80
EXPOSE 443

WORKDIR /usr/local/apache2

### EXECUTION DU CONTENEUR DEPUIS L'IMAGE
ENTRYPOINT [ "httpd", "-D",  "FOREGROUND"]