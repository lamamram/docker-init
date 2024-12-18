FROM debian:12-slim

LABEL author="matt"
LABEL created_at="2024-12-17"
LABEL stack="java"
LABEL stack.version="1.0"

RUN mkdir /opt/tomcat
## BEST PRACTICE: couches qui changent peu et lentes en premier
## BEST PRACTICE: enchaîner avec "&&" les RUN qui créént / modifient / suppriment les mêmes objets
RUN apt-get update && apt-get install -y openjdk-17-jre-headless curl && \
    rm -rf /var/lib/apt/lists/*
RUN curl https://downloads.apache.org/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98.tar.gz -o /opt/tomcat/apache-tomcat-9.0.98.tar.gz && \
    tar -xzvf /opt/tomcat/apache-tomcat-9.0.98.tar.gz -C /opt/tomcat --strip-components=1 && \
    rm -f /opt/tomcat/apache-tomcat-9.0.98.tar.gz
RUN useradd -M -d /opt/tomcat -U tomcat

WORKDIR /opt/tomcat/webapps

ADD https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war .

RUN chown -R tomcat:tomcat /opt/tomcat

USER tomcat

VOLUME [ "/opt/tomcat/webapps" ]

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run" ]
