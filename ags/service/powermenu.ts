import options from "options";

const { lock, sleep, reboot, logout, shutdown } = options.widgets.powermenu;

export type Action = "lock" | "sleep" | "reboot" | "logout" | "shutdown";

class PowerMenu extends Service {
    static {
        Service.register(
            this,
            {},
            {
                title: ["string"],
                cmd: ["string"],
            }
        );
    }

    #title = "";
    #cmd = "";

    get title() {
        return this.#title;
    }
    get cmd() {
        return this.#cmd;
    }

    action(action: Action) {
        [this.#cmd, this.#title] = {
            lock: [lock.value, "Lock"],
            sleep: [sleep.value, "Sleep"],
            reboot: [reboot.value, "Reboot"],
            logout: [logout.value, "Log Out"],
            shutdown: [shutdown.value, "Shutdown"],
        }[action];

        this.notify("cmd");
        this.notify("title");
        this.emit("changed");
        App.closeWindow("powermenu");
        App.openWindow("verification");
    }

    readonly shutdown = () => {
        this.action("shutdown");
    };
}

const powermenu = new PowerMenu();
globalThis["powermenu"] = powermenu;
export default powermenu;
