FROM debian:12-slim

LABEL author="matt"
LABEL created_at="2024-12-17"
LABEL stack="java"
LABEL stack.version="1.0"

## BEST PRACTICE: couches qui changent peu et lentes en premier
## BEST PRACTICE: enchaîner avec "&&" les RUN qui créént / modifient / suppriment les mêmes objets
## BEST PRACTICE: minimiser les couches (&& \)
## BEST PRACTICE: utiliser des chemins absolus
## BEST PRACTICE: on a pas besoin de créer l'archive tomcat en tant que fichier
##              : puisque curl et tar peuvent fonctionner en flux ( | )
RUN mkdir /opt/tomcat && \
    apt-get update && apt-get install -y openjdk-17-jre-headless curl && \
    rm -rf /var/lib/apt/lists/* && \
    curl https://downloads.apache.org/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98.tar.gz | \
    tar -xzv -C /opt/tomcat --strip-components=1 && \
    useradd -M -d /opt/tomcat -U tomcat && \
    curl https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war -o /opt/tomcat/webapps/sample.war && \
    chown -R tomcat:tomcat /opt/tomcat

WORKDIR /opt/tomcat/webapps

USER tomcat

VOLUME [ "/opt/tomcat/webapps" ]

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run" ]
