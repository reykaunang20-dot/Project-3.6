@echo off
echo ===============================================
echo               PROCESS RECOVERY DATA
echo ===============================================
echo.

:: Lokasi sumber (folder simulasi drive D)
set sumber=C:\Users\reyka\OneDrive\Desktop\SimulasiDrive_D

:: Lokasi tujuan (folder simulasi drive C)
set root=C:\Users\reyka\OneDrive\Desktop\SimulasiDrive_C

:: Membuat folder utama jika belum ada
if not exist "%root%" mkdir "%root%"

:: Format tanggal dan waktu
set yr=%date:~10,4%
set mo=%date:~4,2%
set dy=%date:~7,2%
set hr=%time:~0,2%
set mn=%time:~3,2%

set hr=%hr: =0%

set tujuan=%root%\DataRecovery_%yr%%mo%%dy%_%hr%%mn%
set logfile=%root%\recovery_log.txt

mkdir "%tujuan%" >nul 2>&1

echo Menyalin file dari:
echo   %sumber%
echo ke:
echo   %tujuan%
echo.

echo RECOVERY LOG > "%logfile%"
echo Tanggal: %date%   Waktu: %time% >> "%logfile%"
echo Sumber : %sumber% >> "%logfile%"
echo Tujuan : %tujuan% >> "%logfile%"
echo ---------------------------------------------- >> "%logfile%"

xcopy "%sumber%\*" "%tujuan%\" /E /H /C /I /Y >> "%logfile%"

echo ---------------------------------------------- >> "%logfile%"
echo Recovery selesai >> "%logfile%"

echo.
echo ===============================================
echo             RECOVERY SELESAI !!!
echo ===============================================
echo Log File: %logfile%
echo.

pause