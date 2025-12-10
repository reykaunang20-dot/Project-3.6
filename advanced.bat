@echo off
title ADVANCED DATA RECOVERY SYSTEM
color 0B

:: ======== FIX LOKASI ONE DRIVE ========
set "BASE=%USERPROFILE%\OneDrive\Desktop"
set "SOURCE=%BASE%\SimulasiDrive_D"
set "DEST_BASE=%BASE%\SimulasiDrive_C"

:: ======== MENU ========
:MENU
cls
echo ==========================================================
echo                ADVANCED DATA RECOVERY SYSTEM
echo ==========================================================
echo Source Folder: %SOURCE%
echo Destination:   %DEST_BASE%
echo ==========================================================
echo  1. Selective Backup (Pilih Folder)
echo  2. Incremental Backup (Hanya file baru/berubah)
echo  3. Scheduled Backup (Backup tiap X menit)
echo  4. Email Notification (Notifikasi Gmail)
echo  5. Exit
echo ==========================================================
set /p opc=Masukkan pilihan (1-5): 

if "%opc%"=="1" goto SELECTIVE
if "%opc%"=="2" goto INCREMENTAL
if "%opc%"=="3" goto SCHEDULE
if "%opc%"=="4" goto EMAIL
if "%opc%"=="5" exit
goto MENU


:: ==========================================================
:: SELECTIVE BACKUP
:: ==========================================================
:SELECTIVE
cls
echo ---- SELECTIVE BACKUP ----
echo Folder tersedia:
dir "%SOURCE%" /ad /b
echo.
set /p FOLDER=Ketik nama folder yang ingin di-backup: 

:: ===== FIX FORMAT WAKTU =====
set "TS=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%"
set "TS=%TS: =0%"

set "DEST=%DEST_BASE%\Selective_%FOLDER%_%TS%"
mkdir "%DEST%"

xcopy "%SOURCE%\%FOLDER%" "%DEST%" /E /H /C /I /Y

echo.
echo SELESAI! Backup selective tersimpan di:
echo %DEST%
pause
goto MENU


:: ==========================================================
:: INCREMENTAL BACKUP
:: ==========================================================
:INCREMENTAL
cls
echo ---- INCREMENTAL BACKUP ----

set "DEST=%DEST_BASE%\IncrementalBackup"
mkdir "%DEST%" >nul 2>&1

robocopy "%SOURCE%" "%DEST%" /E /XO /LOG:%DEST%\incremental_log.txt

echo.
echo SELESAI! Incremental backup berjalan.
pause
goto MENU


:: ==========================================================
:: SCHEDULED BACKUP
:: ==========================================================
:SCHEDULE
cls
echo ---- SCHEDULED BACKUP ----
set /p interval=Backup berulang setiap berapa menit?: 

echo.
echo Tekan CTRL+C untuk menghentikan proses.
timeout 3 > nul

:LOOP
set "TS=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%"
set "TS=%TS: =0%"

set "DEST=%DEST_BASE%\Schedule_%TS%"
mkdir "%DEST%"

xcopy "%SOURCE%" "%DEST%" /E /H /C /I /Y

echo ----- Backup dilakukan pada %TS% -----

:: Perbaikan timeout
set /a wait=%interval%*60
timeout %wait% >nul

goto LOOP


:: ==========================================================
:: EMAIL NOTIFICATION
:: ==========================================================
:EMAIL
cls
echo ---- EMAIL NOTIFICATION ----
set /p email=Masukkan email Gmail tujuan: 
set /p pesan=Tulis pesan singkat notifikasi: 

powershell -Command ^
"Send-MailMessage -To '%email%' -From '%email%' -Subject 'Backup Selesai' -Body '%pesan%' -SmtpServer 'smtp.gmail.com' -Port 587 -UseSsl -Credential (New-Object PSCredential('%email%',(Read-Host 'Masukkan Password Gmail' -AsSecureString)))"

echo.
echo Email notifikasi dikirim sukses!
pause
goto MENU
