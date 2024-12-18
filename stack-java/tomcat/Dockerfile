## nous allons utiliser une image centos 9: quay.io/centos/centos:stream9
FROM debian:12-slim

# labels/tags clé=valeur
LABEL author="matt"
LABEL created_at="2024-12-17"
LABEL stack="java"
LABEL stack.version="1.0"

## ajouter un dossier /opt/tomcat
# RUN mkdir /opt/tomcat

## injecter le fichier https://downloads.apache.org/tomcat/tomcat-9/v9.0.93/bin/apache-tomcat-9.0.93.tar.gz dans ce dossier
# ADD https://downloads.apache.org/tomcat/tomcat-9/v9.0.93/bin/apache-tomcat-9.0.93.tar.gz /opt/tomcat

## décomprésser dans ce dossier sans dossier intermédiaire 
# RUN curl https://downloads.apache.org/tomcat/tomcat-9/v9.0.93/bin/apache-tomcat-9.0.93.tar.gz -o /opt/tomcat/apache-tomcat-9.0.93.tar.gz
# RUN tar -xzvf /opt/tomcat/apache-tomcat-9.0.93.tar.gz -C /opt/tomcat --strip-components=1
# RUN rm -f /opt/tomcat/apache-tomcat-9.0.93.tar.gz


## installer java (apt-get) et nettoyer le dépôt
# RUN apt-get update && apt-get install -y openjdk-17-jre-headless curl
# RUN rm -rf /var/lib/apt/lists/*

## ajouter un utilisateur tomcat avec le dossier /opt/tomcat comme home et un group tomcat
# RUN useradd -M -d /opt/tomcat -U tomcat

## changer le home de l'image vers /opt/tomcat/webapps
# WORKDIR /opt/tomcat/webapps

## télécharger l'application sample https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war dans le dossier home 
# ADD https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war .

## spécifier le propriétaire et groupe à tomcat 
# RUN chown -R tomcat:tomcat /opt/tomcat

## changer l'utilisateur à tomcat
# USER tomcat

## persister le dossier home pour accéder ou sauvegarder les apps
# VOLUME [ "/opt/tomcat/webapps" ]

## pour communiquer avec httpd avec le port 8080
# EXPOSE 8080

## exécuter de manière statique le binaire en foreground catalina.sh vs startup.sh ???
## ajouter la sous commande pour lancer en one shot run ou start ???
# CMD ["/opt/tomcat/bin/catalina.sh", "run" ]
