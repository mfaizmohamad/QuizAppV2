# Build stage
FROM ubuntu:latest AS build

# Install dependencies
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk curl unzip zip

# Install Gradle
RUN curl -s "https://get.sdkman.io" | bash && \
    bash -c "source /root/.sdkman/bin/sdkman-init.sh && sdk install gradle 7.4.2"

# Set working directory
WORKDIR /app

# Copy all files
COPY . .

# Run Gradle build
RUN bash -c "source /root/.sdkman/bin/sdkman-init.sh && ./gradlew bootJar --no-daemon"

# Runtime stage
FROM openjdk:17-jdk-slim

# Expose the application port
EXPOSE 8080

# Copy the JAR file from the build stage
COPY --from=build /app/build/libs/QuizAppV2-1.jar app.jar

# Set the entry point
ENTRYPOINT ["java", "-jar", "app.jar"]
