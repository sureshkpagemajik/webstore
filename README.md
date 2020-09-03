Pre-requisites  - <br>

  Make sure you have JAVA 8 or JRE 8 installed.<br>
  Make sure you have maven installed.<br>
  Make sure you have git installed.<br>
  Make sure you have docker-compose installed.<br>

To clone this application Run - "git clone https://github.com/Gokulanand-Narayanan/MicroSvcApp.git"

Run "cd MicroSvcApp"

Run "mvn clean package" in the Webstore-Microservice-DockerCompose Directory. This will build all the required war and jar files to run Webstore.

This Project Works with windows and Linux based machines.

Run "docker-compose up -d" This command will create the necessary images to run all the microservices applciations, create the docker containers. 

To ensure all containers started  Run "docker ps -a"

Open the browser and access the application using "http://DOCKER_HOST_IP:8070/webstore"
