FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY target/*.jar app.jar
# We will pass the port dynamically via Entrypoint
ENTRYPOINT ["java", "-jar", "app.jar"]
