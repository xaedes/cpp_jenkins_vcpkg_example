@echo off

if [%~1]==[all] goto all
if [%~1]==[clean] goto clean
if [%~1]==[tools] goto tools
if [%~1]==[build] goto build
if [%~1]==[test] goto test
if [%~1]==[help] goto help
goto help


:all

%~0 clean && %~0 tools && %~0 build && %~0 test


goto exit

:clean
echo Cleaning up...

goto exit

:tools
echo Preparing tools...


goto exit

:build
echo Building...


goto exit

:test
echo Testing...


goto exit

:help

echo Usage:
echo %~0 [all^|clean^|tools^|build^|test^|help]

:exit
