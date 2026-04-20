FROM eclipse-temurin:21-jre-alpine

COPY target/*.jar app.jar

RUN addgroup -S spring && adduser -S spring -G spring

USER spring:spring

ENTRYPOINT ["java", "-jar", "/app.jar"]
