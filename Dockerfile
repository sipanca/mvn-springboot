FROM openjdk:8-jre
ADD target/myproject-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 80
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]