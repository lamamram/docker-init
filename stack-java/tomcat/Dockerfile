FROM debian:12-slim

LABEL author="matt"
LABEL created_at="2024-12-17"
LABEL stack="java"
LABEL stack.version="1.0"

# REMARQUE: ces variables d'environnement ne peuvent pas être modifiées 
#          : qu'au moment du docker run --env HOME 
ENV HOME=/opt/tomcat/webapps

ARG TOMCAT_VERSION_MAJOR=9
ARG TOMCAT_VERSION_FULL

## BEST PRACTICE: couches qui changent peu et lentes en premier
## BEST PRACTICE: enchaîner avec "&&" les RUN qui créént / modifient / suppriment les mêmes objets
## BEST PRACTICE: minimiser les couches (&& \)
## BEST PRACTICE: utiliser des chemins absolus
## BEST PRACTICE: on a pas besoin de créer l'archive tomcat en tant que fichier
##              : puisque curl et tar peuvent fonctionner en flux ( | )
RUN mkdir /opt/tomcat && \
    apt-get update -q && apt-get install -yq openjdk-17-jre-headless curl && \
    rm -rf /var/lib/apt/lists/* && \
    curl https://downloads.apache.org/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_FULL}/bin/apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz | \
    tar -xzv -C /opt/tomcat --strip-components=1 && \
    useradd -M -d /opt/tomcat -U tomcat && \
    curl https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war -o /opt/tomcat/webapps/sample.war && \
    chown -R tomcat:tomcat /opt/tomcat

WORKDIR ${HOME}

USER tomcat

VOLUME [ "/opt/tomcat/webapps" ]

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run" ]
