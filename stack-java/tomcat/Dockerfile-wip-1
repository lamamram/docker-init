## nous allons utiliser une image debian12
# BEST PRACTICE: choisir le tag le + petit
FROM debian:12-slim

## documenter l'image
LABEL author="matt"
LABEL created_at="2024-10-29"
LABEL created_at.year="2024"
LABEL stack="java"
LABEL stack.service="tomcat"

## ajouter un dossier /opt/tomcat
RUN mkdir /opt/tomcat
## injecter le fichier https://downloads.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz dans ce dossier
ADD https://downloads.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz /opt/tomcat
## décomprésser dans ce dossier sans dossier intermédiaire 
# --strip-components=1 n'extrait pas le dossier principal 
RUN tar -xzvf /opt/tomcat/apache-tomcat-9.0.96.tar.gz -C /opt/tomcat --strip-components=1
## et supprimer l'archive
RUN rm -rf /opt/tomcat/apache-tomcat-9.0.96.tar.gz


## installer java (apt-get) # -y pour bypass de la confirmation, -q: quiet moins verbeux
# BEST PRACTICE: utiliser les paquets les + petits
RUN apt-get update && apt-get install -y openjdk-17-jre-headless
## et nettoyer le dépôt apt après
# BEST PRACTICE: nettoyer
RUN rm -rf /var/lib/apt/lists/*

## ajouter un utilisateur tomcat sans dossier home et avec groupe propriétaire
RUN useradd -M -U tomcat 
## spécifier le dossier dans lequel on va atterrir par défaut => /opt/tomcat/webapps
WORKDIR /opt/tomcat/webapps
## télécharger l'application sample https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war dans le dossier workdir
# "." => /opt/tomcat/webapps/
ADD https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war .
## spécifier le propriétaire et groupe à tomcat pour le dossier /opt/tomcat
RUN chown -R tomcat:tomcat /opt/tomcat
## changer l'utilisateur à tomcat
# SUPER BEST PRACTICE: restreindre les droits avec un utilisateur non ROOT
USER tomcat
## persister le dossier workdir pour accéder ou sauvegarder les apps
# REM: ce dossier est remonté dans /var/lib/docker comme un volume nommé sauf qu'il n'a pas de nom !!!
# => --volumes-from
VOLUME [ "/opt/tomcat/webapps" ]
## pour communiquer avec httpd avec le port par défaut de tomcat  ???
EXPOSE 8080
## exécuter de manière statique (sans substitution) le binaire en foreground catalina.sh vs startup.sh ???
## ajouter la sous commande pour lancer en one shot catan ou start ???
CMD [ "/opt/tomcat/bin/catalina.sh", "run" ]

