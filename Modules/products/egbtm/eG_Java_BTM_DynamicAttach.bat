@echo off
REM This tool will do the eG BTM jar dynamic attach to given Java Process ID, Do the Business Transaction Tracing and will report to eG Agent
REM eG Java APM Team @ eG Enterprise - 2019

@setlocal enableextensions
@setlocal EnableDelayedExpansion
@cd /d "%~dp0"


SETLOCAL


:start
SET PID=
SET paramLIST=
SET SCRIPT_DIR=%~dp0
CD %SCRIPT_DIR%

ECHO.
ECHO ******************************************************
ECHO   eG Java BTM Dynamic Attach 
ECHO ******************************************************
ECHO.

REM echo 1stparam : %~1
REM echo 2ndparam : %~2

if /I "%1" == "help" (
	goto :help
)
if /I "%1" == "-help" (
	goto :help
)
if /I "%1" == "-h" (
	goto :help
)

if NOT "%~2" == "" (
	REM SET userJavaHome=%~2
	SET userJavaHome=%2
	REM echo !userJavaHome!
	if /I "%1" == "LIST" (
		SET paramLIST=%~1
	)
	if /I NOT "%1" == "LIST" (
		SET PID=%~1
	)
	goto :SetJavaHome
)

if /I "%1" == "LIST" (
	goto :GetProcessIdList
)

if /I "%1" == "" (
	goto :FindJava
)

if /I NOT "%1" == "LIST" (
	SET PID=%~1
	goto :DynamicAttach
)


goto :exit

:FindJava
IF DEFINED JAVA_HOME (
	ECHO.
	ECHO  JAVA_HOME has been set already
	ECHO.
	echo  Current JAVA_HOME is %JAVA_HOME%
	ECHO.
	ECHO  Current java version and vendor as follows..
	ECHO  -----------------------------------------------------
	REM java -version
	for /f "tokens=*" %%g in ('java -version 2^>^&1') do (
		echo.  %%~g 
		echo.
	)
	ECHO  -----------------------------------------------------
	ECHO.
	
	SET askUserJavaHome=N
	SET /p askUserJavaHome= "Do you want to set different Java Home to run the eG BTM dynamic attach program? : Y/N,  [N]:- "
	if /I "!askUserJavaHome!" == "N" goto :AskProcessListOrPID
	if /I "!askUserJavaHome!" == "Y" goto :AskJavaHome
) ELSE (
	ECHO.
	ECHO 	Could not find any JAVA_HOME. Please specify JAVA_HOME location
	goto :AskJavaHome
)
goto :exit

:AskProcessListOrPID
ECHO.
SET askPID=N
SET /p askPID="Do you know the Java Process ID to dynamically attach eG BTM? : Y/N,  [N]:- "
ECHO.

if /I "%askPID%" == "Y" (
	goto :GetProcessID
)
if /I "%askPID%" == "N" (
	goto :GetProcessIdList
)

goto :exit

:GetProcessID
ECHO.
SET /p getPID="Enter process ID :"

SET PID=%getPID%
REM echo PID %PID%
goto :DynamicAttach
goto :exit

:GetProcessIdList
ECHO.
for /f "tokens=*" %%g in ('java -Xbootclasspath/a:%JAVA_HOME%\lib\tools.jar -cp %SCRIPT_DIR%eg_btm.jar com.eg.agent.Agent LIST 2^>^&1') do (
	echo.  %%~g 
)
ECHO.
ECHO   NOTE: There could be other Java processes which may not be listed above. 
ECHO         If so manually find through process listing commands or task manager. (i.e jps, ps).
ECHO.
goto :GetProcessID
goto :exit

:DynamicAttach

if /I "%PID%" == "exit" (
	goto :exit
)
if /I "%PID%" == "" (
	ECHO.
	ECHO  Please provide the Java Process ID to proceed.
	goto :GetProcessID
)

ECHO.
ECHO    Initiating dynamic attach of eG Java BTM to process ID : %PID%
ECHO.
ECHO.

for /f "tokens=*" %%g in ('java -Xbootclasspath/a:%JAVA_HOME%\lib\tools.jar -cp %SCRIPT_DIR%eg_btm.jar com.eg.agent.Agent %PID% 2^>^&1') do (
	echo.   %%~g 
)
ECHO.
ECHO.
REM ECHO  Done DynamicAttach.
REM ECHO  Dynamic attach process has been completed successfully, ensure the BTM logs to know attachment status.
goto :exit

:AskJavaHome
ECHO.
REM echo Enter EXIT to quit the program
SET userJavaHome=%JAVA_HOME%
SET /p userJavaHome="Enter your JAVA_HOME :   [default JAVA_HOME]:  "

if /I "%userJavaHome%" == "exit" (
	goto :exit
)
if "%userJavaHome%" == "" (
	ECHO Please provide the Java Home to proceed
	goto :AskJavaHome
)
if "%userJavaHome%" == "%JAVA_HOME%" (
	ECHO.
	ECHO  Using default JAVA_HOME
)
goto :SetJavaHome
goto :exit

:SetJavaHome
SET JAVA_HOME=%userJavaHome%
SET PATH=%JAVA_HOME%\bin;%PATH%
ECHO.
ECHO  JAVA_HOME given by user : %JAVA_HOME%
ECHO.

REM Finding java version
for /f "tokens=*" %%g in ('java -version 2^>^&1 ^| findstr /i "version"') do (
	SET JAVAVER=%%~g 
)
if "!JAVAVER!" == "" (
	ECHO  Java version not found. Please provide the valid JAVA_HOME path
	goto :AskJavaHome
)
ECHO.
REM ECHO 	%JAVAVER%
ECHO.
REM ECHO.

ECHO  Java version and vendor as follows..
ECHO  -----------------------------------------------------
REM java -version
for /f "tokens=*" %%g in ('java -version 2^>^&1') do (
	echo.  %%~g 
	echo.
)
ECHO  -----------------------------------------------------
ECHO.

REM ECHO List available in Param  : %paramLIST%
REM ECHO PID available in Param  : %PID%

IF /I "%paramLIST%" == "LIST" (
	REM ECHO LIST found in params: %paramLIST%
	goto :GetProcessIdList
)

IF NOT "%PID%" == "" (
	REM ECHO Given PID : %PID%
	goto :DynamicAttach
)

goto :AskProcessListOrPID
goto :exit

:help

ECHO -------------------------------------------- Help Info ----------------------------------------------------------------
ECHO.
ECHO "	<No Params>			->	"
ECHO "	LIST				->	List out running Java application Process IDs for which eG BTM can be attached dynamically"
ECHO "	<PID>				->	PID is the Java application Process ID to which eG BTM to be attached dynamically"
ECHO "	LIST	<JAVA_HOME>		->	List with Specific Java Home"
ECHO "	<PID>	<JAVA_HOME>		->	PID with specific Java Home"
ECHO.
ECHO ------------------------------------------------------------------------------------------------------------------------

goto:exit

:exit
ECHO.  
ECHO   NOTE:  Please be aware that dynamic attach of BTM jar will only be available until next restart of the application server.
ECHO          In order to have the BTM jar to be added always in Application server, enable it through the application server startup script file. 
ECHO.
ECHO          This approach is best suited for quick POC or troubleshooting while in UAT or DEV environments
ECHO.
ECHO  Exiting....
ECHO.
pause
ENDLOCAL
