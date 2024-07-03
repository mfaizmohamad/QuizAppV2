# Build stage
FROM maven:3.8.1-openjdk-21 AS maven

# Set working directory
WORKDIR /usr/dockeruser/project

# Copy source code and pom.xml
COPY src src/
COPY pom.xml .

# Compile and package the application to an executable JAR
RUN mvn clean package

# Runtime stage
FROM eclipse-temurin:21-jdk-focal

# Create a non-root user
RUN addgroup dockerusergroup && adduser --ingroup dockerusergroup --disabled-password dockeruser

# Set working directory and ownership
WORKDIR /usr/dockeruser/project-executable
RUN chown -R dockeruser /usr/dockeruser

# Switch to the non-root user
USER dockeruser

# Copy the JAR file from the maven stage to the runtime stage
COPY --chown=dockeruser:dockerusergroup --from=maven /usr/dockeruser/project/target/QuizAppV2.jar /usr/dockeruser/project-executable/

# Set the entry point
ENTRYPOINT ["java","-jar","QuizAppV2.jar"]
