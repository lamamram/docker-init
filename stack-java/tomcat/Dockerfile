FROM debian:12-slim

LABEL author="matt"
LABEL created_at="2025-01-28"
LABEL created_at.year="2025"
LABEL stack="java"
LABEL stack.service="tomcat"

## BEST PRACTICE n°1: on place les couches qui change le - souvent
# et nettoyer le dépôt apt-get après
## BEST PRACTICE n°2: rassembler les commandes de création/modification/suppression dans les mêmes couches
# ADD => RUN curl (wget) | RUN ... && \
## BEST PRACTICE n°3: travailler en flux ( | ) et non en fichier !!!
# ajouter un dossier /opt/tomcat
# injecter le fichier https://downloads.apache.org/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98.tar.gz dans ce dossier
# décomprésser dans ce dossier sans dossier intermédiaire 
# et supprimer l'archive
RUN apt-get update && apt-get install -y openjdk-17-jre-headless curl && \
    rm -rf /var/lib/apt/cache/lists/* && \
    mkdir /opt/tomcat && \
    curl https://downloads.apache.org/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98.tar.gz | \
    tar -xvz -C /opt/tomcat --strip-components=1 && \
    useradd -M -d /opt/tomcat -U tomcat && \
    curl https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war -o /opt/tomcat/webapps/sample.war && \
    chown -R tomcat:tomcat /opt/tomcat

WORKDIR /opt/tomcat/webapps

USER tomcat

VOLUME [ "/opt/tomcat/webapps" ]

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]


