# Build stage
FROM openjdk:21-jdk-slim AS build

# Set working directory
WORKDIR /app

# Install necessary packages
RUN apt-get update && apt-get install -y \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Copy all files
COPY . .

# Build the application with Maven
RUN mvn clean package

# Final stage
FROM openjdk:21-jdk-slim

# Set working directory
WORKDIR /app

# Expose port 8080
EXPOSE 8080

# Copy the JAR file from the build stage
COPY --from=build /app/target/QuizAppV2-1.jar app.jar

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
