
@echo off
title Pc Cleaner
color 9
echo Pc cleaner by CodePulse
timeout /T 3 /NOBREAK > nul
cls
color 2
cls
echo Loading.
timeout /t 1 > nul
cls
echo Loading..
timeout /t 1 > nul
cls
echo Loading...
timeout /t 1 > nul
cls
goto start


:start
echo -[1] (Cleaner, Clears temps, prefetchm printers cache and others..)
echo -[2] (Broswer Cleaner, cleans Brsower data, cache and history)
echo -[3] (system optimization and maintenance, Create System Restore Point, deletes folders with same names etc.)
echo -[4] (System Information, will display your info about your pc.)
echo -[5] (Virus And Malware Scanner, Can take some time.)
color 9
echo ======================================================================
set /p PROGRAM= What do you want to do?:
cls
goto %PROGRAM%



:1
@echo off
color 3
echo Starting System Cleanup...

:: Set the current working directory to the root of the C: drive
cd /d C:\

:: Clean up temporary files
echo Cleaning up temporary files...
del /q /s %TEMP%\*.*
for /d %%d in (%TEMP%\*) do rmdir /s /q "%%d"

:: Clean up prefetch files
echo Cleaning up prefetch files...
del /q /s %SystemRoot%\Prefetch\*.*

:: Clean up printer cache
echo Cleaning up printer cache...
net stop spooler
del /q /s %SystemRoot%\System32\spool\printers\*.*
net start spooler

:: Clean up other unimportant files
echo Cleaning up other unimportant files...
del /q /s %SystemRoot%\Temp\*.*
del /q /s %SystemRoot%\Logs\*.*
del /q /s %SystemRoot%\Microsoft.NET\Framework\v*\Temporary ASP.NET Files\*.*
del /q /s %SystemRoot%\SoftwareDistribution\Download\*.*

::Windows Game DVR recordings..
del /s /q "%USERPROFILE%\Videos\Captures\*.mp4"

::Recycle Bin Content
rd /s /q "%USERPROFILE%\AppData\Local\Microsoft\Windows\Explorer\*.db"

echo Cleanup complete.

:: Set up the startup cleanup
set regPath=HKCU\Software\Microsoft\Windows\CurrentVersion\Run
set regName=System Cleanup
set regValue="%~f0" /startup
reg add "%regPath%" /v "%regName%" /t REG_SZ /d "%regValue%" /f
pause
cls
goto start









:2

@echo off
color 3

echo Cleaning up browser data...
echo.

rem Edge
echo Deleting Edge cache and browsing history...
del /q /f /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache\*.*"
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache"
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\GPUCache"
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Service Worker\ScriptCache"
rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Service Worker\CacheStorage"
del /q /f /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cookies"
del /q /f /s "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\History"
echo.

rem Chrome
echo Deleting Chrome cache and browsing history...
del /q /f /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*.*"
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache"
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\GPUCache"
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Service Worker\ScriptCache"
rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Service Worker\CacheStorage"
del /q /f /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cookies"
del /q /f /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\History"
echo.

rem Brave
echo Deleting Brave cache and browsing history...
del /q /f /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Cache\*.*"
rd /s /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Code Cache"
rd /s /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\GPUCache"
rd /s /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Service Worker\ScriptCache"
rd /s /q "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Service Worker\CacheStorage"
del /q /f /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\Cookies"
del /q /f /s "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\History"
echo.

rem Opera
echo Deleting Opera cache and browsing history...
del /q /f /s "%APPDATA%\Opera Software\Opera Stable\Cache\*.*"
rd /s /q "%APPDATA%\Opera Software\Opera Stable\Code Cache"
rd /s /q "%APPDATA%\Opera Software\Opera Stable\GPUCache"
rd /s /q "%APPDATA%\Opera Software\Opera Stable\Service Worker\ScriptCache"
rd /s /q "%APPDATA%\Opera Software\Opera Stable\Service Worker\CacheStorage"
del /q /f /s "%APPDATA%\Opera Software\Opera Stable\Cookies"
del /q /f /s "%APPDATA%\Opera Software\Opera Stable\History"
echo.

echo Cleanup complete!
echo.
pause
cls
goto start




:3
@echo off


:: Find and Remove Duplicate Files
echo Finding Duplicate Files...
for /r %%i in (*) do (
    set "file=%%~nxi"
    set "path=%%~dpi"
    setlocal enabledelayedexpansion
    if exist "!path!!file!" (
        fc /b "%%i" "!path!!file!" >nul && (
            echo Deleting duplicate file "%%i"...
            del /f "%%i"
        )
    )
    endlocal
)
echo.

:: Clean Registry
echo Cleaning Registry...
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /f >nul 2>&1
reg delete HKLM\Software\Microsoft\Windows\CurrentVersion\Run /f >nul 2>&1
echo.

echo PC Cleaner Tool cleanup complete.
pause
cls
goto start




:4
@echo off
echo System Information:
echo -------------------

echo Processor:
wmic cpu get name

echo Memory:
wmic memorychip get capacity
wmic memorychip get speed
wmic memorychip get memorytype

echo Operating System:
wmic os get caption, version, osarchitecture

echo Hard Drive:
wmic diskdrive get size, caption, model

echo Network:
ipconfig /all

echo Sound Device:
wmic sounddev get name

echo Display Device:
wmic desktopmonitor get screenheight, screenwidth, caption

echo -------------------
echo System Information Displayed Successfully.
pause
cls
goto start









:5
@echo off

echo Starting malware and virus scan...

:: Perform a full system scan using Windows Defender
for /f "tokens=* delims=" %%a in ('powershell.exe -Command "Start-MpScan -ScanType FullScan -ScanParameter -DisableRemediation"') do set "ScanResult=%%a"

:: Check the scan results
set "ScanType="
set "ScanStatus="
set "ThreatsDetected="
for /f "tokens=1,2 delims=: " %%a in ("%ScanResult%") do (
    if "%%a"=="ScanType" set "ScanType=%%b"
    if "%%a"=="ScanStatus" set "ScanStatus=%%b"
    if "%%a"=="ThreatsDetected" set "ThreatsDetected=%%b"
)

:: Display the scan results
echo Scan type: %ScanType%
echo Scan status: %ScanStatus%
echo Threats detected: %ThreatsDetected%

echo Malware and virus scan complete.
pause
cls
goto start
