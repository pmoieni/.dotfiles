import type Gtk from "gi://Gtk?version=3.0";
import icons from "lib/icons";
import { uptime } from "lib/variables";
import powermenu, { Action } from "service/powermenu";

const battery = await Service.import("battery");

function up(up: number) {
    const h = Math.floor(up / 60);
    const m = Math.floor(up % 60);
    return `${h}h ${m < 10 ? "0" + m : m}m`;
}

const SysButton = (action: Action) =>
    Widget.Button({
        vpack: "center",
        child: Widget.Icon(icons.powermenu[action]),
        on_clicked: () => powermenu.action(action),
    });

export const Header = () =>
    Widget.Box<Gtk.Widget>(
        { class_name: "header horizontal" },
        Widget.Box({
            vpack: "center",
            children: [
                Widget.Box([
                    // Widget.Icon({ icon: battery.bind("icon_name") }),
                    Widget.Label({
                        className: "user-label",
                        label: `${USER}`,
                    }),
                ]),
                Widget.Separator(),
                Widget.Box([
                    Widget.Icon({ icon: icons.ui.time }),
                    Widget.Label({ label: uptime.bind().as(up) }),
                ]),
            ],
        }),
        Widget.Box({ hexpand: true }),
        Widget.Button({
            vpack: "center",
            child: Widget.Icon(icons.ui.settings),
            on_clicked: () => {
                App.closeWindow("quicksettings");
                App.closeWindow("settings-dialog");
                App.openWindow("settings-dialog");
            },
        }),
        SysButton("logout"),
        SysButton("shutdown")
    );