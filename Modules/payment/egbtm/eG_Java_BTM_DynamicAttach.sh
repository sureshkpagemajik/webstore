#!/bin/sh

echo                                                         
echo "********************************************************"
echo " eG Java BTM Dynamic Attach  "            
echo "********************************************************"

start(){
	FindJava
}

FindJava(){
	tmp1=`which java 2>&1`
	cnt=`echo $tmp1 | grep "no java" | wc -l`
	# cnt=1
	if [ $cnt -eq 1 ]
	then
		getJavaHome
	else
	
		echo  " JAVA_HOME has been set already"
		echo
		echo  " Current JAVA_HOME is $JAVA_HOME"
		echo
		echo  " Current JAVA_HOME link Path: $tmp1"
		echo
		echo  " Current java version and vendor as follows.."
		echo  " -----------------------------------------------------"
		output=$(java -version 2>&1)
		echo  "$output"
		# echo $output > output.txt
		
		# while read line ; do
			# echo "Text read from file: $line"
		# done <<< ( java -version 2>&1)
		# done <<< $output
		# done <"output.txt"
		
		echo  " ----------------------------------------------------- " 
		echo
		
		d1=`dirname $tmp1`
		java_home=`dirname $d1`
		
		echo  
		read -p "Do you want to set different Java Home to run the eG BTM dynamic attach program? : y/n,  [n]:- " askUserJavaHome
		echo  
		# echo ... $askUserJavaHome
		
		if [ "$askUserJavaHome" = "y" ]
		then
			getJavaHome
		else 
			askUserJavaHome="n"
		fi
		# TODO: check case insensitive
		if [ "$askUserJavaHome" = "n" ]
		then
			AskProcessListOrPID
		fi
		
	fi
}
DynamicAttach(){
	echo
	echo "	Doing Dynamic Attach"
	echo
	java -version
	echo
	# echo "	Done DynamicAttach"
	echo
}

getJavaHome() {
	# echo
	read -p "Enter your JAVA_HOME path: [default JAVA_HOME] : " userJava
	echo
	# echo userJava $userJava 

	setJavaHome
}

setJavaHome() {
	export JAVA_HOME=$userJava 
	# echo $JAVA_HOME

	export PATH=$JAVA_HOME/bin:$PATH
	# echo $PATH
	# /opt/jdk1.8.0_45/
	java -version
	
	
	if [ "$list" = "LIST" ] || [ "$list" = "list" ]
	then
		GetProcessIdList
	fi
	
	if [ "$PID" != "" ]
	then
		DynamicAttach
	fi
	echo
	AskProcessListOrPID
}

AskProcessListOrPID(){

	# echo 
	read -p  "Do you know the Java Process ID to dynamically attach eG BTM ? : y/n,  [n]:- " askPID
	# echo 
	
	if [ "$askPID" = "y" ]
	then
		GetProcessID
	else 
		askPID="n"
	fi

	if [ "$askPID" = "n" ]
	then
		GetProcessIdList
	fi

}

GetProcessID(){
	 echo
	 read -p "Enter process ID : " PID
	 echo 
	 # echo $PID
	 DynamicAttach
}
GetProcessIdList() {
	echo
	java -Xbootclasspath/a:$JAVA_HOME/lib/tools.jar -cp .:eg_btm.jar com.eg.agent.Agent LIST
	echo
	echo "NOTE: There could be other Java processes which may not be listed above. "
	echo "      If so manually find through process listing commands or task manager. (i.e jps, ps)."
	echo
	GetProcessID
}
DynamicAttach() {
	if [ "$PID" = "" ]
	then
		echo " Please provide the Java Process ID to proceed"
		GetProcessID
	fi
	
	echo 
	echo "Initiating dynamic attach of eG Java BTM to process ID : $PID"
	echo 
	# java -cp .:eg_btm.jar com.eg.agent.Agent $PID
	outputV=$(java -Xbootclasspath/a:$JAVA_HOME/lib/tools.jar -cp .:eg_btm.jar com.eg.agent.Agent $PID 2>&1)
	echo  "$outputV"
	# echo $outputV > outputV.txt 2>&1
		
	echo 
	# echo " Done DynamicAttach."
	# echo " Dynamic attach process has been completed successfully, ensure the BTM logs to know attachment status"
	echo "NOTE:  Please be aware that dynamic attach of BTM jar will only be available until next restart of the application server."
	echo "       In order to have the BTM jar to be added always in Application server, enable it through the application server startup script file."
	echo 
	echo "       This approach is best suited for quick POC or troubleshooting while in UAT or DEV environments."
	echo 
	
	stop
}

stop(){
	echo 
	echo " Exiting...."
	exit
}

help(){
	echo
	echo "	-------------------------------------------- Help Info -------------------------------------------------------------"
	echo "	<No Params>			->	"
	echo "	LIST				->	List out running Java application Process IDs for which eG BTM can be attached dynamically"
	echo "	<PID>				->	PID is a Process ID which is used for Dynamic Attach"
	echo "	LIST	<JAVA_HOME>		->	List with Specific Java Home"
	echo "	<PID>	<JAVA_HOME>		->	PID with specific Java Home"
	echo "	---------------------------------------------------------------------------------------------------------------------"
	echo
	exit
}

# Reading params start 


if [ "$1" = "help" ] || [ "$1" = "-help" ] || [ "$1" = "-h" ] ||  [ "$1" = "h" ]
then
	help
fi

if [ "$2" != "" ]
then
	userJava=$2
	if [ "$1" = "LIST" ]
	then
		list = $1
	fi

	if [ "$1" != "" ] && [ "$1" != "LIST" ]
	then
		PID=$1
	fi
	
	setJavaHome
	
fi

if [ "$1" = "LIST" ] || [ "$1" = "list" ]
then
	list=$1
	GetProcessIdList
fi

if [ "$1" != "" ] && [ "$1" != "LIST" ] && [ "$1" != "list" ]
then
	PID=$1
	DynamicAttach
fi

# Reading params ends 

start
