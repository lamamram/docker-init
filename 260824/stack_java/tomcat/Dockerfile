## nous allons utiliser une image centos 9: quay.io/centos/centos:stream9
FROM quay.io/centos/centos:stream9

## documenter l'image
LABEL author="mlamamra"
LABEL created_at="2024-08-28"
LABEL created_at.year="2024"
LABEL stack="java"
LABEL stack.item="tomcat"

## ajouter un dossier /opt/tomcat
RUN mkdir /opt/tomcat
## injecter le fichier https://downloads.apache.org/tomcat/tomcat-9/v9.0.93/bin/apache-tomcat-9.0.93.tar.gz dans ce dossier
ADD https://downloads.apache.org/tomcat/tomcat-9/v9.0.93/bin/apache-tomcat-9.0.93.tar.gz /opt/tomcat
## décomprésser dans ce dossier sans dossier intermédiaire 
## et supprimer l'archive


## installer java (yum)
## et nettoyer le dépôt yum après

## ajouter un utilisateur tomcat avec le dossier /opt/tomcat comme home
## changer le home de l'image vers /opt/tomcat/webapps

## télécharger l'application sample https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war dans le dossier home 

## spécifier le propriétaire et groupe à tomcat 
## changer l'utilisateur à tomcat

## persister le dossier home pour accéder ou sauvegarder les apps

## pour communiquer avec httpd avec le port 8080

## exécuter de manière statique (sans substitution) le binaire en foreground catalina.sh vs startup.sh ???

## ajouter la sous commande pour lancer en one shot run ou start ???

