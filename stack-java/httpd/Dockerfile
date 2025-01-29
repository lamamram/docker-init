## multi-staging build
# on va utiliser une image auxilliaire (sidecar)
# qu'on appelle stage a priori numéroté à partir de 0
# stage qu'on va nommé avec un alias AS curl
FROM shakefu/curl-static AS curl
# on cherche une image qui contient / génère un curl en mode standalone avec un simple binaire

## compilation / make install > binaire

FROM httpd:2.4

## documenter et / ou filtrer et / ou configurer tout conteneur associé à cette image
LABEL author="matt"
LABEL created_at="2025-01-28"
LABEL created_at.year="2025"
LABEL stack="java"
LABEL stack.service="httpd"

## rapatrier le curl du stage curl dans l'image du build
                 # chemin côté image curl | # chemin côté image httpd
COPY --from=curl /usr/local/bin/curl        /usr/local/bin/curl

## injecter le fichier de conf central httpd.conf
COPY httpd.conf /usr/local/apache2/conf
# copie du contexte - ".dockerignore" 
# COPY . /usr/local/apache2/conf

RUN mkdir /usr/local/apache2/conf/sites

COPY java_app.conf /usr/local/apache2/conf/sites

## déclarer le ou les ports surlesquels le processus sous jancent d'un conteneur lié à cette image, écoute
# peut être vrai 80 ou faux 443
EXPOSE 80 443

## lancement de la commande en mode avant-plan, au moment docker run
## 1/ commande non substituable par la commande du docker run
# ENTRYPOINT [ "httpd", "-D", "FOREGROUND" ]

## 2/ 
# REM on pourrait installer un script de type "entrypoint.sh" avec le ENTRYPOINT
# ENTRYPOINT [ "httpd" ]
# substituable par la commande du docker run
# CMD [ "-D", "FOREGROUND" ]

## 3/
CMD [ "httpd", "-D", "FOREGROUND" ]

# HEALTHCHECK periodique dans essais (infini)
HEALTHCHECK \
            --start-period=3s \
            --timeout=5s \
            --interval=20s \
            CMD curl http://127.0.0.1:80