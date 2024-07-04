# Use a base image with Java 17 and Maven to build your application
FROM openjdk:17-jdk-slim AS build

# Set working directory inside the image
WORKDIR /app

# Copy Maven build files (pom.xml)
COPY pom.xml ./

# Download dependencies
RUN apt-get update && apt-get install -y maven
RUN mvn dependency:go-offline

# Copy the application source code
COPY src ./src/

# Build the application
RUN mvn package -DskipTests

# Use a smaller base image for runtime
FROM openjdk:17-jdk-slim

# Set working directory inside the image
WORKDIR /app

# Copy the built JAR file from the previous stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port your app runs on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
