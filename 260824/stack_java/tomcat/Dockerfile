## nous allons utiliser une image centos 9: quay.io/centos/centos:stream9
FROM quay.io/centos/centos:stream9

## documenter l'image
LABEL author="mlamamra"
LABEL created_at="2024-08-28"
LABEL created_at.year="2024"
LABEL stack="java"
LABEL stack.item="tomcat"

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
RUN mkdir /opt/tomcat && \
    curl https://downloads.apache.org/tomcat/tomcat-9/v9.0.93/bin/apache-tomcat-9.0.93.tar.gz | \
    tar -xvz -C /opt/tomcat --strip-components=1 && \
    yum update -q && yum install -q -y java && \
    yum clean all && rm -rf /var/cache/yum

## ajouter un utilisateur tomcat sans le dossier /opt/tomcat comme home avec groupe propriétaire
RUN useradd -M -U tomcat
## changer le dossier de travail de l'image vers /opt/tomcat/webapps
WORKDIR /opt/tomcat/webapps
## télécharger l'application sample https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war dans le dossier home 
## REM : curl est plus rapide que ADD sur des fichiers volumineux
RUN curl https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war -o ./sample.war

## spécifier le propriétaire et groupe à tomcat (CHOWN) /opt/tomcat
RUN chown -R tomcat:tomcat /opt/tomcat
## changer l'utilisateur à tomcat
USER tomcat

## persister le dossier de travail pour accéder ou sauvegarder les apps
# créé un volume persistent non nommé dans /var/lib/docker/volume dès le run (usage --volumes-from)
VOLUME [ "/opt/tomcat/webapps" ]
## pour communiquer avec httpd avec le port 8080
EXPOSE 8080
## exécuter de manière statique (sans substitution) le binaire en foreground catalina.sh vs startup.sh ???
# ENTRYPOINT [ "executable" ]
## ajouter la sous commande pour lancer en one shot run ou start ???
CMD [ "/opt/tomcat/bin/catalina.sh", "run" ]
