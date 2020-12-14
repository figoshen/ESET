@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
REM    -------- Update version  --------- 
set mVer=ep7dll
REM    -------- ID & PW  ---------  
set ID=EAV-0267750251
set PW=3vr2krbn3s
set url=update.eset.com
REM ------- Proxy ---------------
:set http_proxy=http://192.168.1.1:808
REM ------------------------------
set here=%~dp0
set wget=%~dps0wget.exe
set tmpfile=%tmp%\update.log
set source=%ID%:%PW%@%url%
set oPath=c:\www\eset_upd
call :version %mVer% 
timeout 10
exit
REM ------------------------------
:version
set ver=%1
if exist %tmpfile% del /Q %tmpfile%
if not exist %oPath%\%ver:dll=\dll%\nul md %oPath%\%ver:dll=\dll%
%wget% -N  -O%tmp%/update.ver http://%source%/eset_upd/%ver:dll=/dll%/update.ver
if exist %tmp%\%ver%.ver  @fc /A /L /LB1 %tmp%\update.ver %tmp%\%ver%.ver && goto next
sed -n "/PICO/,/inte/d;/\[[^HO|^LI|^SE|^CO]/,/size/p"  %tmp%/update.ver> %tmp%\%ver%.ver
sed -n "/_l[0-9]/s@file=@http://%url%@ p" %tmp%\%ver%.ver >%tmp%\%ver%.lst
if exist %tmp%\%ver%.log del /f %tmp%\%ver%.log
%wget% -N -b -o %tmp%\%ver%.log -e --user=%ID% --password=%PW% -P %oPath%\%ver:dll=\dll% -i %tmp%\%ver%.lst
sed "s@file=\/.*\/@file=@g"  %tmp%\%ver%.ver > %oPath%\%ver:dll=\dll%\update.ver
goto :next
exit
REM ------------------------------
:next
cd %here%
move /y %tmp%\update.ver %tmp%\%ver%.ver
shift 
@if %1.==. goto :eof
goto :version
exit
