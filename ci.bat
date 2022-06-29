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

if exist "%~dp0\tools\" (
    rmdir /Q /S "%~dp0\tools\"
)
if exist "%~dp0\build\" (
    rmdir /Q /S "%~dp0\build\"
)

goto exit

:tools
echo Preparing tools...

if not exist "%~dp0\tools\" (
    mkdir "%~dp0\tools\"
)
if not exist "%~dp0\tools\vcpkg\vcpkg" (
    git clone https://github.com/microsoft/vcpkg.git "%~dp0\\tools\\vcpkg\\"
    "%~dp0\tools\vcpkg\bootstrap-vcpkg.bat" -disableMetrics
)


goto exit

:build
echo Building...

rem set VCPKG_FEATURE_FLAGS=versions
set BUILD_TYPE=Release
set VCPKG_TARGET_TRIPLET=x64-windows
echo on
cmake -B %~dp0\build\Windows\Win64 -G "Ninja" -DCMAKE_BUILD_TYPE=%BUILD_TYPE% -DCMAKE_TOOLCHAIN_FILE=%~dp0\tools\vcpkg\scripts\buildsystems\vcpkg.cmake %~dp0
cmake --build %~dp0\build\Windows\Win64
echo off
goto exit

:test
echo Testing...

echo on
ctest --test-dir "%~dp0\build\Windows\Win64\example_tests\" 
echo off

goto exit

:help

echo Usage:
echo %~0 [all^|clean^|tools^|build^|test^|help]

:exit
