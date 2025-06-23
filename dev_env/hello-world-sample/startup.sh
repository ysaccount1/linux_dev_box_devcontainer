#!/bin/bash

# Create Maven wrapper
cd /app/dev_env/hello-world-sample
mvn package
#Run the program without debugging
#java -jar target/demo-0.0.1-SNAPSHOT.jar

#Run the program with debugging
mvn spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
