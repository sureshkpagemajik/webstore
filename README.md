Pre-requisites  - <br>

  Make sure you have JAVA 8 or JRE 8 installed.<br>
  Make sure you have maven installed.<br>
  Make sure you have git installed.<br>
  Make sure you have docker-compose installed.<br>

Step 1: To clone this application Run - "git clone https://github.com/Gokulanand-Narayanan/MicroSvcApp.git"

Step 2: Run "cd MicroSvcApp"

Step 3: Run "mvn clean package" in the Webstore-Microservice-DockerCompose Directory. This will build all the required war and jar files to run Webstore.

This Project Works with windows and Linux based machines.

To start containers without BTM enabled

Step 1: Navigate to directory "MicroSvcApp/"  

Step 2: Run "docker-compose up -d" This command will create the necessary images to run all the microservices applciations, create the docker containers. 

To ensure all containers started  Run "docker ps -a"

Open the browser and access the application using "http://DOCKER_HOST_IP:8070/webstore"


To start with BTM enabled 

Step 1: Install the eG agent on the docker host machine "Copy the command from eG Manager to install agent".

Step 2: Navigate to directory "MicroSvcApp/btm_volume_mount/" 

Step 3: Step 2: Run "docker-compose up -d" This command will create the necessary images to run all the microservices applciations, create the docker containers.

To ensure all containers started  Run "docker ps -a"

Open the browser and access the application using "http://DOCKER_HOST_IP:8070/webstore"

