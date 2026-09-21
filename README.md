# Capacitor wrapper for narazborku.ru

This repo wraps our Next.js site as a native Android WebView app.

## Build APK

```bash
npm install
npx cap add android
# Copy build from main site repo:
mkdir -p out && cp -r ../web/.next/static/* out/
npx cap sync android
cd android && ./gradlew assembleDebug
# APK: android/app/build/outputs/apk/debug/app-debug.apk
```

## GitHub Actions

On every push to main, `.github/workflows/build.yml` automatically
builds APK. Download from Actions tab.

## Capacitor + FCM for push notifications

See `android/app/src/main/AndroidManifest.xml` for notification
permissions. FCM token registration handled by
`@capacitor-community/fcm` plugin.
