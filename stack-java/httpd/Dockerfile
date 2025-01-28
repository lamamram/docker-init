FROM httpd:2.4

## documenter et / ou filtrer et / ou configurer tout conteneur associé à cette image
LABEL author="matt"
LABEL created_at="2025-01-28"
LABEL created_at.year="2025"
LABEL stack="java"
LABEL stack.service="httpd"

## injecter le fichier de conf central httpd.conf
COPY httpd.conf /usr/local/apache2/conf
# copie du contexte - ".dockerignore" 
# COPY . /usr/local/apache2/conf

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