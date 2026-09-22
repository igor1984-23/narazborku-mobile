/** @type {import('@capacitor/cli').CapacitorConfig} */
const config = {
    appId: "ru.narazborku.app",
    appName: "НаРазборку",
    webDir: "out",
    server: {
        url: "https://narazborku.ru",
        androidScheme: "https",
        cleartext: false
    },
    android: {
        allowMixedContent: false,
        captureInput: true
    }
};
module.exports = config;
