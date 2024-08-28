# multistaging build
# j'utilise le contenu d'une image auxilliaire
# par exemple: compilation dans une image de travail qui contient un compilateur
# et qui transfère le un binaire executable créé => dans l'image effective du build
# par exemple: n'importe quel outil de build dont on a pas besoin pour l'image finale
FROM shakefu/curl-static AS curl

## autrechose utile


# image de base image publique OU privée (registry) ou scratch (rien pour ditrub ou application en binaire)
FROM httpd:2.4

LABEL author="mlamamra"
LABEL created_at="2024-08-27"
LABEL created_at.year="2024"
LABEL stack="java"
LABEL stack.item="httpd"

# transfert du binaire exe curl de l'image référencée "curl" vers notre image finale
COPY --from=curl /usr/local/bin/curl /usr/local/bin/curl

# ajout de la conf en local dans l'image
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

RUN mkdir /usr/local/apache2/conf/sites

COPY java_app.conf /usr/local/apache2/conf/sites/java_app.conf


EXPOSE 80
EXPOSE 443

WORKDIR /usr/local/apache2

### EXECUTION DU CONTENEUR DEPUIS L'IMAGE
## 1ère façon
# REM: ENTRYPOINT donne une commande non substituable avec le docker run
# ENTRYPOINT [ "httpd", "-D",  "FOREGROUND"]

## 2ème façon
# ENTRYPOINT [ "httpd"]
# # REM: CMD donne une commande substituable avec le docker run
# CMD ["-D",  "FOREGROUND"]

## 3ème façon
CMD [ "httpd", "-D",  "FOREGROUND"]


## REM: HEALTHCHECK périodique (sans retries)
HEALTHCHECK \
           --start-period=5s \
           --timeout=5s \
           --interval=3s \
           CMD curl http://127.0.0.1