import { defineConfig } from "@capacitor/cli";

/**
 * Capacitor configuration for narazborku.ru.
 *
 * This wraps our Next.js site as a native Android WebView app.
 * The app loads https://narazborku.ru in a fullscreen WebView
 * and shows push notifications via FCM.
 *
 * Workflow:
 *   1. npm install
 *   2. npx cap add android
 *   3. npx cap sync android
 *   4. cd android && ./gradlew assembleDebug
 *   5. APK at android/app/build/outputs/apk/debug/app-debug.apk
 *
 * GitHub Actions builds APK on every push to main. See
 * .github/workflows/build.yml. Download artifact from
 * Actions tab and place at narazborku.ru/public/downloads/.
 */

export default defineConfig({
    appId: "ru.narazborku.app",
    appName: "НаРазборку",
    webDir: "out",
    server: {
        androidScheme: "https"
    },
    android: {
        allowMixedContent: false,
        captureInput: true
    }
});
