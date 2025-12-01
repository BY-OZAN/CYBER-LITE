@echo off
setlocal EnableDelayedExpansion
title CYBER LITE :: PROFESSIONAL SYSTEM DIAGNOSTIC
color 0a
mode con: cols=110 lines=50
chcp 65001 > nul

:: YONETICI KONTROLU
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:STARTUP
cls
echo.
echo.
echo          ███████╗  ██╗   ██╗  ██████╗   ███████╗  ██████╗ 
echo          ██╔════╝  ╚██╗ ██╔╝  ██╔══██╗  ██╔════╝  ██╔══██╗
echo          ██║        ╚████╔╝   ██████╔╝  █████╗    ██████╔╝
echo          ██║         ╚██╔╝    ██╔══██╗  ██╔══╝    ██╔══██╗
echo          ███████╗     ██║     ██████╔╝  ███████╗  ██║  ██║
echo          ╚══════╝     ╚═╝     ╚═════╝   ╚══════╝  ╚═╝  ╚═╝
echo.
echo          ██╗       ██╗  ████████╗  ███████╗
echo          ██║       ██║  ╚══██╔══╝  ██╔════╝
echo          ██║       ██║     ██║     █████╗  
echo          ██║       ██║     ██║     ██╔══╝  
echo          ███████╗  ██║     ██║     ███████╗
echo          ╚══════╝  ╚═╝     ╚═╝     ╚══════╝
echo.
echo.
echo                      [████████████████████] 
echo                     Sistem verileri toplanıyor...
echo.
timeout /t 2 >nul

:: DETAYLI VERI CEKME
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).Name.Trim()"`) do set "cpuName=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).NumberOfCores"`) do set "cpuCores=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).NumberOfLogicalProcessors"`) do set "cpuThreads=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).MaxClockSpeed"`) do set "cpuSpeed=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).LoadPercentage"`) do set "cpuLoad=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).L2CacheSize"`) do set "L2CacheSize=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).L3CacheSize"`) do set "L3CacheSize=%%a"

for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize / 1KB, 0)"`) do set "totalRAM=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1KB, 0)"`) do set "freeRAM=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Speed -Average).Average"`) do set "ramSpeed=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_PhysicalMemory | Select -First 1).Manufacturer"`) do set "ramManu=%%a"

for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "[math]::Round((Get-Volume -DriveLetter C).Size / 1GB, 0)"`) do set "diskTotal=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "[math]::Round((Get-Volume -DriveLetter C).SizeRemaining / 1GB, 0)"`) do set "diskFree=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-PhysicalDisk | Select -First 1).MediaType"`) do set "diskType=%%a"

for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_VideoController | Select -First 1).Name"`) do set "gpuName=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "[math]::Round((Get-CimInstance Win32_VideoController | Select -First 1).AdapterRAM / 1GB, 0)"`) do set "gpuRAM=%%a"

for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_BaseBoard).Manufacturer"`) do set "mbManu=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_BaseBoard).Product"`) do set "mbModel=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion"`) do set "biosVer=%%a"

for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).Caption"`) do set "osName=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).Version"`) do set "osVer=%%a"
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "$t = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime; '{0}g {1}s' -f $t.Days, $t.Hours"`) do set "uptime=%%a"

:: HESAPLAMALAR
set /a usedRAM=%totalRAM% - %freeRAM%
set /a ramPercent=(%usedRAM% * 100) / %totalRAM%
set /a usedDisk=%diskTotal% - %diskFree%
set /a diskPercent=(%usedDisk% * 100) / %diskTotal%

:: BAR OLUSTURMA
set /a ramBarLen=%ramPercent% / 5
set "ramBar="
for /L %%i in (1,1,%ramBarLen%) do set "ramBar=!ramBar!█"
for /L %%i in (!ramBarLen!,1,19) do set "ramBar=!ramBar!░"

set /a cpuBarLen=%cpuLoad% / 5
set "cpuBar="
for /L %%i in (1,1,%cpuBarLen%) do set "cpuBar=!cpuBar!█"
for /L %%i in (!cpuBarLen!,1,19) do set "cpuBar=!cpuBar!░"

set /a diskBarLen=%diskPercent% / 5
set "diskBar="
for /L %%i in (1,1,%diskBarLen%) do set "diskBar=!diskBar!█"
for /L %%i in (!diskBarLen!,1,19) do set "diskBar=!diskBar!░"

:DISPLAY
cls
echo ══════════════════════════════════════════════════════════════════════════════════════════════════════
echo    ███████╗ ██╗   ██╗ ██████╗  ███████╗ ██████╗     ██╗      ██╗ ████████╗ ███████╗
echo    ██╔════╝ ╚██╗ ██╔╝ ██╔══██╗ ██╔════╝ ██╔══██╗    ██║      ██║ ╚══██╔══╝ ██╔════╝
echo    ██║       ╚████╔╝  ██████╔╝ █████╗   ██████╔╝    ██║      ██║    ██║    █████╗  
echo    ██║        ╚██╔╝   ██╔══██╗ ██╔══╝   ██╔══██╗    ██║      ██║    ██║    ██╔══╝  
echo    ███████╗    ██║    ██████╔╝ ███████╗ ██║  ██║    ███████╗ ██║    ██║    ███████╗
echo    ╚══════╝    ╚═╝    ╚═════╝  ╚══════╝ ╚═╝  ╚═╝    ╚══════╝ ╚═╝    ╚═╝    ╚══════╝
echo                                  Professional System Diagnostic Tool
echo ══════════════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo  ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
echo  │ [CPU] PROCESSOR INFORMATION                                                                     │
echo  ├─────────────────────────────────────────────────────────────────────────────────────────────────┤
echo  │  Model          : %cpuName%
echo  │  Cores          : %cpuCores% Cores / %cpuThreads% Threads
echo  │  Base Speed     : %cpuSpeed% MHz
echo  │  L2 Cache       : %L2CacheSize% KB
echo  │  L3 Cache       : %L3CacheSize% KB
echo  │  Current Load   : %cpuLoad%%% [%cpuBar%]
echo  └─────────────────────────────────────────────────────────────────────────────────────────────────┘
echo.
echo  ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
echo  │ [RAM] MEMORY INFORMATION                                                                        │
echo  ├─────────────────────────────────────────────────────────────────────────────────────────────────┤
echo  │  Total Memory   : %totalRAM% MB
echo  │  Used Memory    : %usedRAM% MB (%%%ramPercent%)
echo  │  Free Memory    : %freeRAM% MB
echo  │  Memory Speed   : %ramSpeed% MHz
echo  │  Manufacturer   : %ramManu%
echo  │  Usage          : [%ramBar%] %%%ramPercent%
echo  └─────────────────────────────────────────────────────────────────────────────────────────────────┘
echo.
echo  ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
echo  │ [GPU] GRAPHICS INFORMATION                                                                      │
echo  ├─────────────────────────────────────────────────────────────────────────────────────────────────┤
echo  │  Graphics Card  : %gpuName%
echo  │  Video Memory   : %gpuRAM% GB
echo  └─────────────────────────────────────────────────────────────────────────────────────────────────┘
echo.
echo  ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
echo  │ [DISK] STORAGE INFORMATION (C:)                                                                 │
echo  ├─────────────────────────────────────────────────────────────────────────────────────────────────┤
echo  │  Total Capacity : %diskTotal% GB
echo  │  Used Space     : %usedDisk% GB (%%%diskPercent%)
echo  │  Free Space     : %diskFree% GB
echo  │  Disk Type      : %diskType%
echo  │  Usage          : [%diskBar%] %%%diskPercent%
echo  └─────────────────────────────────────────────────────────────────────────────────────────────────┘
echo.
echo  ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
echo  │ [SYSTEM] PLATFORM INFORMATION                                                                   │
echo  ├─────────────────────────────────────────────────────────────────────────────────────────────────┤
echo  │  Motherboard    : %mbManu% %mbModel%
echo  │  BIOS Version   : %biosVer%
echo  │  Operating Sys  : %osName%
echo  │  OS Version     : %osVer%
echo  │  System Uptime  : %uptime%
echo  └─────────────────────────────────────────────────────────────────────────────────────────────────┘
echo.
echo ══════════════════════════════════════════════════════════════════════════════════════════════════════
echo.
echo          ██████╗   ██╗   ██╗       ██████╗   ███████╗   █████╗   ███╗   ██╗
echo          ██╔══██╗  ╚██╗ ██╔╝      ██╔═══██╗  ╚══███╔╝  ██╔══██╗  ████╗  ██║
echo          ██████╔╝   ╚████╔╝       ██║   ██║    ███╔╝   ███████║  ██╔██╗ ██║
echo          ██╔══██╗    ╚██╔╝        ██║   ██║   ███╔╝    ██╔══██║  ██║╚██╗██║
echo          ██████╔╝     ██║         ╚██████╔╝  ███████╗  ██║  ██║  ██║ ╚████║
echo          ╚═════╝      ╚═╝          ╚═════╝   ╚══════╝  ╚═╝  ╚═╝  ╚═╝  ╚═══╝
echo.
echo ══════════════════════════════════════════════════════════════════════════════════════════════════════
echo                              [R] Yenile  [Q] Cikis
echo ══════════════════════════════════════════════════════════════════════════════════════════════════════

choice /c RQ /n >nul
if errorlevel 2 exit
if errorlevel 1 goto STARTUP