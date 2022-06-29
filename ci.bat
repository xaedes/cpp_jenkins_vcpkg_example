@echo off

set BUILD_TYPE=Release
set TARGET_TRIPLET=x64-windows
set TESTS_PROJECT=example_tests

set DIR=%~dp0

rem ---------------------------------------------------------------------------
if not [%~4]==[] set TESTS_PROJECT=%~4
if not [%~3]==[] set TARGET_TRIPLET=%~3
if not [%~2]==[] set BUILD_TYPE=%~2

echo %~0 %*
echo BUILD_TYPE:     %BUILD_TYPE%
echo TARGET_TRIPLET: %TARGET_TRIPLET%
echo TESTS_PROJECT:  %TESTS_PROJECT%
set ARGS=%BUILD_TYPE% %TARGET_TRIPLET% %TESTS_PROJECT%
rem ---------------------------------------------------------------------------
if [%~1]==[all]         goto all
if [%~1]==[clean]       goto clean
if [%~1]==[tools]       goto tools
if [%~1]==[build]       goto build
if [%~1]==[test]        goto test
if [%~1]==[build_test]  goto build_test
if [%~1]==[help]        goto help
if [%~1]==[-]           goto build_test
%0 build_test %*
goto exit

rem ---------------------------------------------------------------------------
:all
%~0 clean %ARGS% && %~0 tools %ARGS% && %~0 build %ARGS% && %~0 test %ARGS%
goto exit

rem ---------------------------------------------------------------------------
:build_test
%~0 build %ARGS% && %~0 test %ARGS%
goto exit

rem ---------------------------------------------------------------------------
:clean
echo Cleaning up...
if exist "%~dp0\tools\" (
    rmdir /Q /S "%DIR%\tools\"
)
if exist "%DIR%\build\" (
    rmdir /Q /S "%DIR%\build\"
)
goto exit

rem ---------------------------------------------------------------------------
:tools
echo Preparing tools...
if not exist "%DIR%\tools\" (
    mkdir "%DIR%\tools\"
)
if not exist "%DIR%\tools\vcpkg\vcpkg" (
    git clone https://github.com/microsoft/vcpkg.git "%DIR%\\tools\\vcpkg\\"
    "%DIR%\tools\vcpkg\bootstrap-vcpkg.bat" -disableMetrics
)
goto exit

rem ---------------------------------------------------------------------------
:build
echo Building...
rem set VCPKG_FEATURE_FLAGS=versions
set VCPKG_TARGET_TRIPLET=%TARGET_TRIPLET%
echo on
cmake -B %DIR%\build\Windows\%TARGET_TRIPLET% -G "Ninja" -DCMAKE_BUILD_TYPE=%BUILD_TYPE% -DCMAKE_TOOLCHAIN_FILE=%DIR%\tools\vcpkg\scripts\buildsystems\vcpkg.cmake %DIR%
cmake --build %DIR%\build\Windows\%TARGET_TRIPLET%
@echo off
goto exit

rem ---------------------------------------------------------------------------
:test
echo Testing...
echo on
ctest --test-dir "%DIR%\build\Windows\%TARGET_TRIPLET%\%TESTS_PROJECT%\" 
@echo off
goto exit

rem ---------------------------------------------------------------------------
:help
echo Usage:
echo %~0 [all^|clean^|tools^|build^|test^|build_test^|-^|help]

rem ---------------------------------------------------------------------------
:exit
