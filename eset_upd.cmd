@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
REM    -------- Update version  --------- 
set mVer=ep7dll v13dll
REM    -------- ID & PW  ---------  
set ID=TRIAL-0270694529
set PW=4psfpvxuce
set url=update.eset.com
REM ------- Proxy ---------------
:set http_proxy=http://192.168.1.1:808
REM ------------------------------
set here=%~dp0
set wget=%~dps0wget.exe
set tmpfile=%tmp%\update.log
set source=%ID%:%PW%@%url%

call :version %mVer% 
ping 127.0.0.1 -n 10 >nul >nul
exit

:version
set ver=%1
if exist %tmpfile% del /Q %tmpfile%
if not exist eset_upd\%ver:dll=\dll%\nul md eset_upd\%ver:dll=\dll%
%wget% -N  -O%tmp%/update.ver http://%source%/eset_upd/%ver:dll=/dll%/update.ver
if exist %tmp%\%ver%.ver  @fc /A /L /LB1 %tmp%\update.ver %tmp%\%ver%.ver && goto next
sed -n "/PICO/,/inte/d;/\[[^H\|^CO]/,/size/p"  %tmp%/update.ver> %tmp%\%ver%.ver
sed -n "/_l[0-9]/s@file=@http://%url%@ p" %tmp%\%ver%.ver >%tmp%\%ver%.lst
if exist %tmp%\%ver%.log del /f %tmp%\%ver%.log
%wget% -N -b -o %tmp%\%ver%.log -e --user=%ID% --password=%PW% --no-if-modified-since -P %ver:dll=/dll% -i %tmp%\%ver%.lst
sed "s@file=\/.*\/@file=@g"  %tmp%\%ver%.ver > eset_upd\%ver:dll=\dll%\update.ver
goto :next
exit

:next
cd %here%
move /y %tmp%\update.ver %tmp%\%ver%.ver
shift 
@if %1.==. goto :eof
goto :version
exit