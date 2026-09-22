@echo off
REM scripts/sign-apk.bat — подписать APK релизным ключом для Xiaomi/Xiaomi-like устройств
REM Использование: sign-apk.bat [input.apk] [output.apk]
setlocal

set ANDROID_SDK=C:\AndroidSDK
set BUILD_TOOLS=%ANDROID_SDK%\build-tools\34.0.0
set APKSIGNER="%BUILD_TOOLS%\apksigner.bat"
set KEYSTORE_DIR=C:\Users\iaraf\.android
set KEYSTORE=%KEYSTORE_DIR%\release.keystore
set KEY_ALIAS=narazborku
set KEY_PASS=narazborku123
set STORE_PASS=narazborku123

set INPUT=%~1
set OUTPUT=%~2
if "%INPUT%"=="" set INPUT=android\app\build\outputs\apk\debug\app-debug.apk
if "%OUTPUT%"=="" set OUTPUT=android\app\build\outputs\apk\debug\app-release-signed.apk

echo === APK: %INPUT%
if not exist "%INPUT%" (
    echo [ERROR] not found: %INPUT%
    exit /b 1
)

if not exist "%KEYSTORE%" (
    echo === Creating release keystore at %KEYSTORE%
    "%JAVA_HOME%\bin\keytool.exe" -genkeypair -v ^
        -keystore "%KEYSTORE%" ^
        -alias %KEY_ALIAS% ^
        -keyalg RSA -keysize 2048 -validity 10000 ^
        -storepass %STORE_PASS% -keypass %KEY_PASS% ^
        -dname "CN=NaRazborku,O=NaRazborku LLC,L=Moscow,C=RU"
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
