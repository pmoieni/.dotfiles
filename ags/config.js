import GLib from "gi://GLib?version=2.0";

Object.assign(globalThis, {
    OPTIONS: `${GLib.get_user_cache_dir()}/ags/options.json`,
    TMP: `${GLib.get_tmp_dir()}/ags`,
    USER: GLib.get_user_name(),
});

Utils.ensureDirectory(TMP);

const main = `${TMP}/main.js`;
const entry = `${App.configDir}/main.ts`;

try {
    await Utils.execAsync([
        "bun",
        "build",
        entry,
        "--outfile",
        main,
        "--external",
        "resource://*",
        "--external",
        "gi://*",
        "--external",
        "file://*",
    ]);
    await import(`file://${main}`);
} catch (error) {
    console.error(error);
    App.quit();
}

export {};
