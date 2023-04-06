@echo off

setlocal EnableDelayedExpansion


rem Check for updates
curl -s https://raw.githubusercontent.com/AdamxzV3/PC-cleaner/main/version.txt > version.txt

rem Compare versions
set /p version=<version.txt
if "%version%"=="%PC_CLEANER_VERSION%" (
    echo No update available.
    pause
    exit /b 0
)

rem Download new version
curl -s -o PC_cleaner.bat https://raw.githubusercontent.com/AdamxzV3/PC-cleaner/main/PC_cleaner.bat

if errorlevel 1 (
    echo Update failed. Please try again later.
    pause
    exit /b 1
)

echo Update complete.
pause
