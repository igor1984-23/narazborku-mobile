/** @type {import('@capacitor/cli').CapacitorConfig} */
const config = {
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
};

module.exports = config;
