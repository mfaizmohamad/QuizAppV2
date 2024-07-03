# Use a base image with Java 21 and Maven/Gradle to build your application
FROM adoptopenjdk:21-jdk-hotspot AS build

# Set working directory inside the image
WORKDIR /app

# Copy Maven/Gradle build files (pom.xml or build.gradle)
COPY pom.xml ./
# If using Gradle, use: COPY build.gradle ./

# Download dependencies and plugins
RUN mvn dependency:go-offline
# For Gradle, use: RUN gradle build --no-daemon

# Copy the application source code
COPY src ./src/

# Build the application
RUN mvn package -DskipTests
# For Gradle, use: RUN gradle build --no-daemon

# Use a smaller base image for runtime
FROM adoptopenjdk:21-jre-hotspot

# Set working directory inside the image
WORKDIR /app

# Copy the built JAR file from the previous stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port your app runs on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
