@echo off
REM scripts/sign-apk.bat — подписать APK релизным ключом для Xiaomi/Xiaomi-like устройств
REM Использование: sign-apk.bat [input.apk] [output.apk]
REM
REM Пароли НЕ хранятся в этом файле. Задать через переменные окружения:
REM   set ANDROID_SDK=C:\Users\iaraf\AppData\Local\Android\Sdk
REM   set KEYSTORE=C:\Users\iaraf\.android\release.keystore
REM   set KEY_ALIAS=narazborku
REM   set STORE_PASS=<пароль keystore>
REM   set KEY_PASS=<пароль ключа>
setlocal

if "%ANDROID_SDK%"=="" set ANDROID_SDK=C:\Users\iaraf\AppData\Local\Android\Sdk
set BUILD_TOOLS=%ANDROID_SDK%\build-tools\34.0.0
set APKSIGNER="%BUILD_TOOLS%\apksigner.bat"
if "%KEYSTORE%"=="" set KEYSTORE=%USERPROFILE%\.android\release.keystore
if "%KEY_ALIAS%"=="" set KEY_ALIAS=narazborku

set INPUT=%~1
set OUTPUT=%~2
if "%INPUT%"=="" set INPUT=android\app\build\outputs\apk\debug\app-debug.apk
if "%OUTPUT%"=="" set OUTPUT=android\app\build\outputs\apk\debug\app-release-signed.apk

if "%STORE_PASS%"=="" (
    echo [ERROR] STORE_PASS is not set.
    echo         set STORE_PASS=... before running this script.
    exit /b 1
)

echo === APK: %INPUT%
if not exist "%INPUT%" (
    echo [ERROR] not found: %INPUT%
    exit /b 1
)

if not exist "%KEYSTORE%" (
    echo [ERROR] keystore not found: %KEYSTORE%
    echo         Keystore is NOT in git. Generate it once and keep it locally.
    exit /b 1
)

echo === Aligning + signing with release key
"%BUILD_TOOLS%\zipalign.exe" -p -f 4 "%INPUT%" "%OUTPUT%.aligned"
%APKSIGNER% sign ^
    --ks "%KEYSTORE%" ^
    --ks-key-alias %KEY_ALIAS% ^
    --ks-pass pass:%STORE_PASS% ^
    --key-pass pass:%KEY_PASS% ^
    --out "%OUTPUT%" ^
    "%OUTPUT%.aligned"

del "%OUTPUT%.aligned"

echo === Verifying
%APKSIGNER% verify --print-certs "%OUTPUT%"

echo.
echo === DONE: %OUTPUT%
endlocal
