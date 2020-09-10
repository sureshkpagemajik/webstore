<h2>Java Based Micro Services ECommerce Application</h2> 
<h2>This application can be executed in following modes</h2> 
<ol>
  <li>Run the application without APM Agent attached to it</li>
  <li>Run the application with APM Agent using volume mount approach</li>
  <li>Run the application using embedded APM Agent</li>
</ol>
<h2>Pre-requisites</h2> 
<ul>
  <li>Make sure you have JAVA 8 or JRE 8 installed.</li>
  <li>Make sure you have maven installed.</li>
  <li>Make sure you have git installed.</li>
  <li>Make sure you have docker-compose installed.</li>
</ul>
<b><u>Step 1 :</u></b> To clone this application
<pre><code>git clone https://github.com/Gokulanand-Narayanan/MicroSvcApp.git
</code></pre>
<b><u>Step 2 :</u></b> Navigate to application home directory 
<pre><code>cd MicroSvcApp
</code></pre>
<b><u>Step 3 :</u></b> To build the application 
<pre><code>mvn clean package
</code></pre>

<h2>To start containers without BTM enabled</h2>

<b><u>Step 1 :</u></b> Navigate to application home directory 

<pre><code>MicroSvcApp
</code></pre>

<b><u>Step 2 : To build docker images and run all the application containers</u></b>

<pre><code>docker-compose up -d
</code></pre>

To ensure all containers started and running <code>docker ps -a</code>

Open the browser and access the application using "http://DOCKER_HOST_IP:8070/webstore"


<h2>To start with BTM enabled </h2>

<b><u>Step 1 :</u></b> Install the agent on the docker host machine "Copy the command from Manager to install agent".

<b><u>Step 2 :</u></b> Navigate to directory "MicroSvcApp/btm_volume_mount/" 

<b><u>Step 3 :</u></b> Step 2: Run "docker-compose up -d" This command will create the necessary images to run all the microservices applciations, create the docker containers.

To ensure all containers started  Run "docker ps -a"

2Methods:
step 1: chmod +777 copyegbtm.*
step 2: sh copyegbtm.sh 
step 3: run docker-compose -f btm_volume_mount/docker-compose.yaml  up -d or 
        run docker-compose -f btm_volume_mount/docker-compose.yaml  up -d
    

Open the browser and access the application using "http://DOCKER_HOST_IP:8070/webstore"


<h2>THIS IS FOR THE PURPOSES OF TRAINING OR INTERNAL USE ONLY, DO NOT SHARE TO CUSTOMER/PROSPECT/OTHERS</h2> 

