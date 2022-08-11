@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
color 9F
REM    -------- Multi Process  ---------
set /a MultiProcess=10
set wwwroot=c:\wwwroot
set here=%~dp0
set wget=wget.exe -N
set aria=aria2c.exe --allow-overwrite=true
set /a no=0&set /a MultiProcess=%MultiProcess%-1
set list=version_versionid_build_type_level_category_base_date_platform_group_buildregname_file_size
REM    -------- Update from offical site --------- 
set ID=%1
set PW=%2
if %ID%.==. (set ID=EAV-0340035634&set PW=dnuvjf4n54)
if %PW%.==. (set ID=EAV-0340035634&set PW=dnuvjf4n54)
set url=update.eset.com/eset_upd/ep9
set oPath=%wwwroot%\eset_upd\
call :version
set url=update.eset.com/eset_upd/v4/
set oPath=%wwwroot%\eset_upd\v4
call :version
REM    -------- Update from privated server --------- 

set ID=&set PW=
set Tool=wget.
set url=0859.f3322.net:2221/
set oPath=%wwwroot%\eset_upd\f3322
call :version

set Tool=wget
set url=nod.av86.ru/up/dll/
set oPath=%wwwroot%\eset_upd\av86\dll
call :version
ping 127.0.0.1 -n 10 >nul >nul

exit

:version
if %url:~-1%.==/. set url=%url:~,-1%
if %ID%:%PW%==: (set source=%url%) else (set source=%ID%:%PW%@%url%)
set tmpfile=%tmp%\tmp.lst
echo %oPath%|find /i "dll" && set ddll=.dll|| set ddll=
if exist %tmpfile% del /Q %tmpfile%
if not exist %oPath%\NUL md %oPath%
if not exist %oPath%\update.ver set /a MultiProcess=5

Rem Download update.ver
if "%Tool%"=="wget" (
	%wget% -O %tmp%\update.ver http://%source%/update.ver||goto next >nul >nul
)  else (
	%aria% -d %tmp% http://%source%/update.ver||goto next >nul >nul
)

sed -e "/STATS/,$ d" %tmp%\update.ver>%tmp%\tmp.ver
sed -n "/\[[^SERVERS|^LINKS|^HOSTS]/,$ p" %tmp%\tmp.ver|sed -e "/PICO/,/inte/d"> %tmp%\pSVR.ver
echo %source% | find /i "eset.com" >nul&& call :Domain %source:/= %

FOR /F "eol=; tokens=1,2* delims==" %%i in (%tmp%\pSVR.ver) do ( 
	echo %%i |find /i "file" >nul&& (set cut=size&&GOTO :step1)
	echo %%i |find /i "size" >nul&& (set cut=file&&GOTO :step1)
)

:step1
sed -e "/CONT/,/%cut%/d" %tmp%\pSVR.ver>%tmp%\tmp.ver
sed -e "/HASH/,/hash/d" -e "/STATS/,/server/d" %tmp%\tmp.ver>%tmp%\pSVR.ver
cd /d %oPath%
FOR /F "eol=; tokens=1,2* delims==" %%i in (%tmp%\pSVR.ver) do (
        Set _%%i=%%j
        echo %%i | find "[">nul&& set item=%%i
		if not !_file!.==. (if not !_size!.==. Call :download !_file!)
	)
ping 127.0.0.1 -n10 >nul>nul
move /y %tmpfile% update.ver

:next
cd /d %here%
goto :eof

:download
set dFile=http://%source%/%_file%
echo %item%>>%tmpfile%
CALL :Lcase %item:~1,-1%
set _file=%U2L%%ddll%.nup
for %%x in (%list:_= %) do (if not !_%%x!.==. echo %%x=!_%%x!>>%tmpfile% )
:echo file=%_File% >>%tmpfile%
if %no% geq %MultiProcess% ( set /a no=0 ) else ( set /a no=%no% +1)
if %no% equ %MultiProcess%  ( set st=start/wait/min ) else ( set st=start/min)
echo %no% Downloading %_file%  %dFile%
if "%Tool%"=="wget" (
	%st% %wget% -O %_file%  %dFile%
) else (
	%st% %aria% -o %_file%  %dFile%
)
set _size=&goto :eof
:Domain
echo %1 %2 %3 %4
set source=%1
goto :eof
:Lcase
set U2L=%1
for %%i in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do call set U2L=%%U2L:%%i=%%i%%
goto :eof
