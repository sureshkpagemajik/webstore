Run "mvn clean package" in the Webstore-Microservice-DockerCompose Directory. This will build all the required war and jar files to run Webstore.

This Project Works with windows and Linux based machines. The docker-compose file is built for windows based machines out-the-box, 

To run it in linux machines replace the '\' in build-context to '/' in docker-compose.yml file. 

Run "docker-compose up" to run the webstore and access it through 8070 port.