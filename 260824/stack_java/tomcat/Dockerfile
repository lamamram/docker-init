## nous allons utiliser une image centos 9: quay.io/centos/centos:stream9
FROM quay.io/centos/centos:stream9

## documenter l'image
LABEL author="mlamamra"
LABEL created_at="2024-08-28"
LABEL created_at.year="2024"
LABEL stack="java"
LABEL stack.item="tomcat"

# création && / || modification variables => pour le run
ENV MY_USER=tomcat

# injection de paramètres depuis le build
ARG TOMCAT_VERSION_MAJOR=9
ARG TOMCAT_VERSION_FULL

## ajouter un dossier /opt/tomcat
## injecter le fichier https://downloads.apache.org/tomcat/tomcat-9/v9.0.93/bin/apache-tomcat-9.0.93.tar.gz dans ce dossier
## décomprésser dans ce dossier sans dossier intermédiaire 
## et supprimer l'archive
## installer java (yum)
## et nettoyer le dépôt yum après
## OPTIMISATION 
# 1. minimiser les couches de RUN avec &&
# 2. créer des couches uniques enchaînant les créations / modifications / suppressions à cause du Copy On Write
# 3. Essayer de travailler en flux et non en fichier 
## pour aller plus loin
# 1. installer un jre nu via les sources (n'existe sur yum)
# 2. Si possible utiliser un FROM alpine
RUN mkdir /opt/tomcat && \
    curl https://downloads.apache.org/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_FULL}/bin/apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz | \
    tar -xvz -C /opt/tomcat --strip-components=1 && \
    yum update -q && yum install -q -y java-1.8.0-openjdk-headless && \
    yum clean all && rm -rf /var/cache/yum

## ajouter un utilisateur tomcat sans le dossier /opt/tomcat comme home avec groupe propriétaire
RUN useradd -M -U ${MY_USER}
## changer le dossier de travail de l'image vers /opt/tomcat/webapps
WORKDIR /opt/tomcat/webapps
## télécharger l'application sample https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war dans le dossier home 
## REM : curl est plus rapide que ADD sur des fichiers volumineux
## spécifier le propriétaire et groupe à tomcat (CHOWN) /opt/tomcat
RUN curl https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war -o ./sample.war && \
    chown -R tomcat:tomcat /opt/tomcat
## changer l'utilisateur à tomcat
USER ${MY_USER}

## persister le dossier de travail pour accéder ou sauvegarder les apps
# créé un volume persistent non nommé dans /var/lib/docker/volume dès le run (usage --volumes-from)
VOLUME [ "/opt/tomcat/webapps" ]
## pour communiquer avec httpd avec le port 8080
EXPOSE 8080
## exécuter de manière statique (sans substitution) le binaire en foreground catalina.sh vs startup.sh ???
# ENTRYPOINT [ "executable" ]
## ajouter la sous commande pour lancer en one shot run ou start ???
CMD [ "/opt/tomcat/bin/catalina.sh", "run" ]

# warning: le CMD de HEALTHCHECK est allérgique du lancement de type tokens ["", ""]
# après le lancement du CMD précédent (docker run),
# on attent 3s (start-period)
# pour lancer CMD du HEALTHCHECK avec un timeout de 5s,
# si le CMD est vrai (exit-code 0) => le docker ps donne un STATUS (healthy),
# sinon on peut réessayer 3x (retries), avec une durée d'attente de 3s(interval)
HEALTHCHECK \
           --start-period=3s \
           --timeout=5s \
           --retries=3 \
           --interval=3s \
           CMD grep "Server startup" /opt/tomcat/logs/catalina.*.log
