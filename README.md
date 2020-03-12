The jars and wars may be out dated, so do a mvn clean and package in the projects with .pom file.

This Project Works with windows and Linux based machines. The docker-compose file is built for windows based machines out-the-box, 

To run it in linux machines change the '\' in build-context to '/' as Windows uses backslash(\) and linux uses (/). 

Run docker-compose up to run the webstore and access it through 8070 port.