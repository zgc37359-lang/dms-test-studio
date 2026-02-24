@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

set ZIPNAME=DMS_Test_Studio_Windows_1.0.0.zip
set PART1=DMS_Test_Studio_Windows_1.0.0.zip.part01
set PART2=DMS_Test_Studio_Windows_1.0.0.zip.part02
set PART3=DMS_Test_Studio_Windows_1.0.0.zip.part03
set PART4=DMS_Test_Studio_Windows_1.0.0.zip.part04

if not exist "%PART1%" echo Missing %PART1% & exit /b 1
if not exist "%PART2%" echo Missing %PART2% & exit /b 1
if not exist "%PART3%" echo Missing %PART3% & exit /b 1
if not exist "%PART4%" echo Missing %PART4% & exit /b 1

echo [1/3] Merging split package...
copy /b "%PART1%+%PART2%+%PART3%+%PART4%" "..\%ZIPNAME%" >nul
if errorlevel 1 echo Merge failed & exit /b 1

echo [2/3] Extracting package...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '..\%ZIPNAME%' -DestinationPath '..' -Force"
if errorlevel 1 echo Extract failed & exit /b 1

echo [3/3] Launching app...
start "" "..\DMS Test Studio\DMS Test Studio.exe"

echo Done.
exit /b 0
