# Build stage
FROM ubuntu:latest AS build

# Install dependencies
RUN apt-get update && \
    apt-get install -y openjdk-21-jdk curl unzip zip

# Install SDKMAN! and Java
RUN curl -s "https://get.sdkman.io" | bash && \
    bash -c "source /root/.sdkman/bin/sdkman-init.sh && sdk install java 21.0.0.r8-grl"

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Run Gradle build with verbose output and error logging
RUN bash -c "source /root/.sdkman/bin/sdkman-init.sh && ./gradlew bootJar --no-daemon --stacktrace | tee build.log"

# Runtime stage
FROM openjdk:21-jdk-slim

# Expose application port
EXPOSE 8080

# Copy the JAR file from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Set entry point
ENTRYPOINT ["java", "-jar", "app.jar"]
