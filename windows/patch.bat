@echo off
setlocal EnableDelayedExpansion

set GAMEFILE=resources.gpak
set HASHFILE=hashsum.txt
set TMPHASH=hash_current.txt

title Patching Mewgenics to remove lyrics.

REM --- Check if gamefile exists ---
if not exist "%GAMEFILE%" (
    echo ERROR: %GAMEFILE% not found.
    pause
    exit /b 1
)

REM --- Initial cleanup ---
rmdir /s /q Output
del "%TMPHASH%"

REM --- Calculate hash ---
echo Calculating Hashsum...
title Calculating Hashsum...
certutil -hashfile "%GAMEFILE%" SHA256 | findstr /R /V "hash CertUtil" > "%TMPHASH%"

REM --- No hashfile exists -> patch ---
if not exist "%HASHFILE%" (
    echo No has found, patching game...
    goto PATCH
)

REM --- Compare hashes ---
set /p OLDHASH=<"%HASHFILE%"
set /p NEWHASH=<"%TMPHASH%"

if /I "%OLDHASH%"=="%NEWHASH%" (
    echo The game is already patched.
    del "%TMPHASH%"
    start "" Mewgenics.exe
    exit /b 0
)

:PATCH
REM --- Patching ---
title Extracting gamefiles...
".\GPAK.Extractor.exe" "%GAMEFILE%"
title Patching...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0patch_music.ps1"
title Packing new gamefiles...
.\GPAK.Extractor.exe Output

REM --- Cleanup & replace ---
rmdir /s /q Output
del "%TMPHASH%"

del "%GAMEFILE%"
ren Output.gpak "%GAMEFILE%"

REM --- Write new hashsum ---
certutil -hashfile "%GAMEFILE%" SHA256 | findstr /R /V "hash CertUtil" > "%HASHFILE%"


echo Patching done. The voices are gone.
start "" Mewgenics.exe
