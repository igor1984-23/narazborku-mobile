// scripts/build-apk.mjs — собрать APK через Capacitor + Gradle
// Использование: node scripts/build-apk.mjs
import { execSync, spawnSync } from "node:child_process";
import { existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");
process.chdir(root);

const ANDROID_SDK = process.env.ANDROID_SDK_ROOT || "C:\\AndroidSDK";
const JAVA_HOME = process.env.JAVA_HOME || "C:\\JDK\\jdk17";
const env = {
    ...process.env,
    ANDROID_HOME: ANDROID_SDK,
    ANDROID_SDK_ROOT: ANDROID_SDK,
    JAVA_HOME: JAVA_HOME,
    PATH: `${JAVA_HOME}\\bin;${ANDROID_SDK}\\platform-tools;${ANDROID_SDK}\\build-tools\\34.0.0;${process.env.PATH}`,
};

function run(cmd, opts = {}) {
    console.log(`\n→ ${cmd}\n`);
    const r = spawnSync(cmd, { shell: true, stdio: "inherit", env, ...opts });
    if (r.status !== 0) throw new Error(`${cmd} failed: exit ${r.status}`);
}

// 1. cap sync
run("npx cap sync android");

// 2. gradlew assembleDebug
const gradlew = path.join(root, "android", "gradlew.bat");
if (!existsSync(gradlew)) throw new Error(`not found: ${gradlew}`);
run(`"${gradlew}" assembleDebug`);

const apk = path.join(root, "android", "app", "build", "outputs", "apk", "debug", "app-debug.apk");
if (!existsSync(apk)) throw new Error(`APK not built: ${apk}`);
console.log(`\n✅ APK готов: ${apk}`);
