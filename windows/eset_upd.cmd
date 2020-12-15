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
set www=eset_upd
set background=1
call :version %mVer% 
timeout 10
exit

Rem ------------------------------
:version   
set ver=%1
if "%background%"=="1" set bg=-b -o %tmp%\%ver%.log
if exist %tmpfile% del /Q %tmpfile%
if not exist %www%\%ver:dll=\dll%\nul md %www%\%ver:dll=\dll%
%wget% -N  -O%tmp%/update.ver http://%source%/eset_upd/%ver:dll=/dll%/update.ver

REM --------------  Check for updates --------------------
:if exist %tmp%\%ver%.ver  @fc /A /L /LB1 %tmp%\update.ver %tmp%\%ver%.ver && goto next

sed -n "/\[[^CO|^HO|^SE|^LI|^PI]/,/size/p"  %tmp%/update.ver> %tmp%\%ver%.ver
sed -n "/_l[0-9]/s@file=@http://%url%@ p" %tmp%\%ver%.ver >%tmp%\%ver%.lst
if exist %tmp%\%ver%.log del /f %tmp%\%ver%.log
%wget% -N %bg% -e --user=%ID% --password=%PW% -P %www%\%ver:dll=\dll% -i %tmp%\%ver%.lst
echo [STATS_SERVER]  >%www%\%ver:dll=%\update.ver
echo server=http;DESKTOP-NQRRPDA;2221;/updater_plugin_url/storage_file/ >>%www%\%ver:dll=%\update.ver
sed "s@file=\/.*\/@file=@g"  %tmp%\%ver%.ver > %www%\%ver:dll=\dll%\update.ver
echo [STATS_SERVER]  >>%www%\%ver:dll=\dll%\update.ver
echo server=http;DESKTOP-NQRRPDA;2221;/updater_plugin_url/storage_file/ >>%www%\%ver:dll=\dll%\update.ver
goto :next

REM ------------------------------
:next
cd %here%
move /y %tmp%\update.ver %tmp%\%ver%.ver
shift 
if %1.==. goto :eof
goto :version
