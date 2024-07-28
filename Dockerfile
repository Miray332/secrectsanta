# Use the official OpenJDK image from the Docker Hub
FROM openjdk:8u151-jdk-alpine3.7

# Install necessary tools
RUN apk update && apk add --no-cache curl tar bash

# Install Maven
RUN curl -O https://archive.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz \
    && tar xzf apache-maven-3.6.3-bin.tar.gz -C /opt \
    && ln -s /opt/apache-maven-3.6.3 /opt/maven \
    && ln -s /opt/maven/bin/mvn /usr/bin/mvn

# Set environment variables for Maven
ENV MAVEN_HOME /opt/maven
ENV PATH $MAVEN_HOME/bin:$PATH

# Set the working directory to /app
WORKDIR /app

# Copy the project files to the container
COPY . /app

# Run Maven to build the project
RUN mvn clean package

# Set the application home directory
ENV APP_HOME /usr/src/app

# Copy the built JAR file to the application directory
COPY target/secretsanta-0.0.1-SNAPSHOT.jar $APP_HOME/app.jar

# Set the working directory to the application home directory
WORKDIR $APP_HOME

# Expose port 8080
EXPOSE 8080

# Define the entry point for the container
ENTRYPOINT ["java", "-jar", "app.jar"]
