# Build stage
FROM maven:3.8.4-openjdk-17 AS maven

WORKDIR /usr/dockeruser/project

COPY src src
COPY pom.xml .

# Compile and package the application to an executable JAR
RUN mvn package

# Runtime stage
FROM adoptopenjdk/openjdk17:jdk-17.0.2_8-alpine

RUN addgroup dockerusergroup && adduser --ingroup dockerusergroup --disabled-password dockeruser

ARG JAR_FILE=QuizAppV2.jar

WORKDIR /usr/dockeruser/project-executable

RUN chown -R dockeruser /usr/dockeruser

USER dockeruser

# Copy the JAR file from the maven stage to the current stage
COPY --chown=dockeruser:dockerusergroup --from=maven /usr/dockeruser/project/target/${JAR_FILE} /usr/dockeruser/project-executable/

ENTRYPOINT ["java", "-jar", "QuizAppV2.jar"]
