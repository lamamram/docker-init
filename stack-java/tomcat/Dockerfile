FROM debian:12-slim

LABEL author="matt"
LABEL created_at="2024-10-29"
LABEL created_at.year="2024"
LABEL stack="java"
LABEL stack.service="tomcat"

## optimisation n°2: chaîner les RUN et convertir ADD en RUN curl pour minimiser les couches 
# et SURTOUT pour rassembler les commandes creation / modifs / suppression dans les mêmes couches

## optimisation n°3: travailler en flux non en fichier !!
#     curl https://downloads.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz -o /opt/tomcat/apache-tomcat-9.0.96.tar.gz && \
#     tar -xzvf /opt/tomcat/apache-tomcat-9.0.96.tar.gz -C /opt/tomcat --strip-components=1 && \
#     rm -rf /opt/tomcat/apache-tomcat-9.0.96.tar.gz && \

# |: prend le flux de sortie de curl (comportement normal) en entrée du tar suivant (comportement normal)
RUN mkdir /opt/tomcat && \
    useradd -M -U tomcat && \
    apt-get update && apt-get install -y openjdk-17-jre-headless curl && \
    rm -rf /var/lib/apt/lists/* && \
    curl https://downloads.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz | \
    tar -xzv -C /opt/tomcat --strip-components=1 && \
    curl https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war -o /opt/tomcat/webapps/sample.war && \
    chown -R tomcat:tomcat /opt/tomcat

WORKDIR /opt/tomcat/webapps
USER tomcat
VOLUME [ "/opt/tomcat/webapps" ]
EXPOSE 8080
CMD [ "/opt/tomcat/bin/catalina.sh", "run" ]