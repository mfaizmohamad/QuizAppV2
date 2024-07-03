# Build stage
FROM openjdk:21-jdk-slim AS build

# Set working directory
WORKDIR /app

# Copy Gradle build files
COPY . .

# Run Gradle build
RUN ./gradlew bootJar --no-daemon

# Runtime stage
FROM openjdk:21-jdk-slim

# Set working directory
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose application port
EXPOSE 8080

# Set entry point
ENTRYPOINT ["java", "-jar", "app.jar"]
