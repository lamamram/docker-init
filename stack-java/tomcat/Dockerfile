FROM debian:12-slim

LABEL author="matt"
LABEL created_at="2025-01-28"
LABEL created_at.year="2025"
LABEL stack="java"
LABEL stack.service="tomcat"

## création / modification de variables d'environnement
## modifiable au moment du docker run --env --env-file
ENV USER=tomcat

## création / modification de variables d'environnement
## modifiable au moment du docker build --build-arg
ARG TOMCAT_VERSION_MAJOR=9
ARG TOMCAT_VERSION_FULL

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
    curl https://downloads.apache.org/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_FULL}/bin/apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz | \
    tar -xvz -C /opt/tomcat --strip-components=1 && \
    useradd -M -d /opt/tomcat -U ${USER} && \
    curl https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war -o /opt/tomcat/webapps/sample.war && \
    chown -R ${USER}:${USER} /opt/tomcat

WORKDIR /opt/tomcat/webapps

USER ${USER}

VOLUME [ "/opt/tomcat/webapps" ]

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]

# quand le docker run est lancé
# le CMD ci dessus est lancé
# 1. on attent <start-period>
# 2. le CMD du HEALTHCHECK est lancé
# 3.1. le // termine avant le <timeout> avec le code 0 => SUCESS => (healthy) dans le STATUS du docker ps
# 3.2. le // termine avant le <timeout> avec un code non-zero => ERROR (unhealthy)
# 3.3. le // ne termine pas avant le <timeout>
# si 3.2 ou 3.3 => on reessaye <retries> fois
# si 3.2 ou 3.3 => avant de réessayer on attend <interval>s
## REM: le CMD doit être écrit sans JSON
HEALTHCHECK \
            --start-period=3s \
            --timeout=5s \
            --retries=3 \
            --interval=3s \
            CMD grep "Server startup" /opt/tomcat/logs/catalina.*.log


