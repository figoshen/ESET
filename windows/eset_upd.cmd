@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
REM    -------- Multiple Version  --------- 
set mVer=v4 ep9dll v15dll
REM    -------- ID & PW  ---------  
set ID=TRIAL-0270694529
set PW=4psfpvxuce
set url=update.eset.com
REM ------- Proxy ---------------
:set http_proxy=http://192.168.1.1:808
REM ------ format:YYYYMMDD depand on your pc setup
set toDay=%date:~0,4%%date:~5,2%%date:~8,2%
REM ------------------------------
set here=%~dp0
set wget=%~dps0wget.exe
set tmpfile=%tmp%\update.log
set source=%ID%:%PW%@%url%
set OutPut=d:\download\eset_upd
set WebPort=0
set background=1
set check-upd=1
call :version %mVer% 
timeout 10
exit

Rem ------------------------------
:version   
set ver=%1
if "%background%"=="1" set bg=-b -o %tmp%\%ver%.log
if exist %tmpfile% del /Q /F %tmpfile%
if not exist %OutPut%\%ver:dll=\dll%\nul md %OutPut%\%ver:dll=\dll%
%wget% -N  -O%tmp%/update.ver http://%source%/eset_upd/%ver:dll=/dll%/update.ver
REM ---------  check for newest update
if %check-upd%.==1. if exist %tmp%\%ver%.ver  @fc /A /L /LB1 %tmp%\update.ver %tmp%\%ver%.ver && goto next
sed -n "/\[[^SERVERS|^LINKS|^HOSTS]/,$ p" %tmp%/update.ver |sed -e "/CONT/,/size/d" -e "/MOBI/,/size/d" -e "/PICO/,/inte/d"> %tmp%\%ver%.ver
REM ------------- download today's first
sed -n "/(%today%)/,/file/p" %tmp%\%ver%.ver > %tmp%\tmp.txt
type %tmp%\%ver%.ver >> %tmp%\tmp.txt
#sed -n "/_l[0-9]/s@file=@http://%url%@p" %tmp%\tmp.txt >%tmp%\%ver%.lst
sed -n "/file/s@file=@http://%url%@p" %tmp%\tmp.txt >%tmp%\%ver%.lst
if exist %tmp%\%ver%.log del /f /q %tmp%\%ver%.log
%wget% -N %bg% -e --user=%ID% --password=%PW% -P %OutPut%\%ver:dll=\dll% -i %tmp%\%ver%.lst
sed "s@file=\/.*\/@file=@g"  %tmp%\%ver%.ver > %OutPut%\%ver:dll=\dll%\update.ver
echo [STATS_SERVER]  >>%OutPut%\%ver:dll=\dll%\update.ver
echo server=http;%COMPUTERNAME%;%WebPort%;/updater_plugin_url/storage_file/ >>%OutPut%\%ver:dll=\dll%\update.ver
goto :next

REM ------------------------------
:next
move /y %tmp%\update.ver %tmp%\%ver%.ver
shift 
if %1.==. goto :eof
goto :version
