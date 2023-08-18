# FROM openjdk:18-alpine   
# VOLUME /tmp                   
# EXPOSE 8080                   
# ADD target/spring-boot-complete-0.0.1-SNAPSHOT.jar spring-boot-complete-0.0.1-SNAPSHOT.jar 
# ENTRYPOINT ["java","-jar","/spring-boot-complete-0.0.1-SNAPSHOT.jar"] 


## Build Project Springboot
FROM maven:3.9-eclipse-temurin-17-alpine AS builder
WORKDIR /build
COPY . .
RUN mvn clean package -DskipTests
 
FROM eclipse-temurin:17.0.5_8-jre-alpine@sha256:02c04793fa49ad5cd193c961403223755f9209a67894622e05438598b32f210e
WORKDIR /app
EXPOSE 8080
COPY --from=builder /build/target/spring-boot-complete-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]