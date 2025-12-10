@echo off

setlocal enabledelayedexpansion
echo ===============================================
echo               PROCESS RECOVERY DATA
echo ===============================================
echo.

:: Lokasi sumber (folder simulasi drive D)
set sumber=C:\Users\reyka\OneDrive\Desktop\SimulasiDrive_D

:: Lokasi tujuan (folder simulasi drive C)
set root=C:\Users\reyka\OneDrive\Desktop

:: Membuat folder utama SimulasiDrive_C jika belum ada
if not exist "%root%" mkdir "%root%"

:: Format tanggal dan waktu
set yr=%date:~10,4%
set mo=%date:~4,2%
set dy=%date:~7,2%
set hr=%time:~0,2%
set mn=%time:~3,2%

:: Hilangkan spasi pada jam
set hr=%hr: =0%

set tujuan=%root%\DataRecovery_%yr%%mo%%dy%_%hr%%mn%
mkdir "%tujuan%"

echo Folder Recovery: %tujuan%
echo. 

:: Hitung Jumlah File PDF dan DOCX
set count=0
for /r "%sumber%" %%f in (*.pdf *.docx) do (
set /a count+=1
)

echo total file ditemukan: %count%
echo.

:: Proses Recovery
set num=0
for /r "%sumber%" %%f in (*.pdf *.docx) do (
set /a num+=1
echo [!num!/%count%] Menyalin: %%~nxf

:: Buat folder tujuan sama persis dengan sumber
set "rel=%%~dpf"
set "rel=!rel:%sumber%=!"
if not exist "%tujuan%!rel!" mkdir "%tujuan%!rel!"

:: Salin file
xcopy "%%f" "%tujuan%!rel!" >nul 2>&1

:: Verifikasi ukuran file
for %%A in ("%%f") do set size1=%%~zA
for %%B in ("%tujuan%!rel!%%~nxf") do set size2=%%~zB

if "!size1!"=="!size2!" (
	echo Verifikasi: OK
  ) else (
	echo Verifikasi: Gagal
  )
)

echo.
echo Membuat File ZIP...
set zipfile=%root%\DataRecovery_%yr%%mo%%dy%_%hr%%mn%.zip
echo Membuat zip: %zipfile%

:: ZIP PAKAI POWERSHELL (built-in Windows)
powershell -command "Compress-Archive -Path '%tujuan%\*' -DestinationPath '%zipfile%'"

echo.
echo ===============================================
echo            TUGAS 2 SELESAI !!!
echo ===============================================
echo hasil ZIP: %zipfile%.zip
echo.
pause