import GLib from "gi://GLib";
import icons from "lib/icons";
import { dependencies, sh, bash } from "lib/utils";

const now = () => GLib.DateTime.new_now_local().format("%Y-%m-%d_%H-%M-%S");

class Recorder extends Service {
    static {
        Service.register(
            this,
            {},
            {
                timer: ["int"],
                recording: ["boolean"],
            }
        );
    }

    #recordings = Utils.HOME + "/Videos/Recordings";
    #screenshots = Utils.HOME + "/Pictures/Screenshots";
    #file = "";
    #interval = 0;

    recording = false;
    timer = 0;

    async start(full = true) {
        if (!dependencies("slurp", "wl-screenrec")) return;

        if (this.recording) return;

        Utils.ensureDirectory(this.#recordings);
        this.#file = `${this.#recordings}/${now()}.mp4`;
        sh(
            `wl-screenrec  ${full ? "" : `-g "${await sh("slurp")}"`} -f ${this.#file}`
        );

        this.recording = true;
        this.changed("recording");

        this.timer = 0;
        this.#interval = Utils.interval(1000, () => {
            this.changed("timer");
            this.timer++;
        });
    }

    async stop() {
        if (!this.recording) return;

        await bash("killall -INT wl-screenrec");
        this.recording = false;
        this.changed("recording");
        GLib.source_remove(this.#interval);

        Utils.notify({
            iconName: icons.fallback.video,
            summary: "Screenrecord",
            body: this.#file,
            actions: {
                "Show in Files": () => sh(`xdg-open ${this.#recordings}`),
                View: () => sh(`xdg-open ${this.#file}`),
            },
        });
    }

    async screenshot(full = true) {
        if (!dependencies("slurp", "grim", "swappy")) return;

        const file = `${this.#screenshots}/${now()}.png`;
        Utils.ensureDirectory(this.#screenshots);

        const wayshot = `grim ${full ? "" : `-g "${await sh("slurp")}"`} ${file}`;
        await sh(wayshot);
        bash(`wl-copy < ${file}`);

        Utils.notify({
            image: file,
            summary: "Screenshot",
            body: this.#file,
            actions: {
                "Show in Files": () => sh(`xdg-open ${this.#screenshots}`),
                View: () => sh(`xdg-open ${file}`),
                Edit: () => {
                    if (dependencies("swappy")) sh(`swappy -f ${file}`);
                },
            },
        });
    }
}

const recorder = new Recorder();
globalThis["recorder"] = recorder;
export default recorder;
