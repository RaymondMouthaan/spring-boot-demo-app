ARG ARCH=amd64
ARG JDK=adoptopenjdk:11-jre-openj9-bionic

FROM $ARCH/$JDK

COPY target/demo-app-0.0.1-SNAPSHOT.jar app.jar
RUN sh -c 'touch /app.jar'

EXPOSE 8443
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
