import icons from "lib/icons";
import { uptime } from "lib/variables";
import powermenu, { Action } from "service/powermenu";

function up(up: number) {
    const h = Math.floor(up / 60);
    const m = Math.floor(up % 60);
    return `${h}h ${m < 10 ? "0" + m : m}m`;
}

const SysButton = (action: Action) =>
    Widget.Button({
        vpack: "center",
        child: Widget.Icon(icons.powermenu[action]),
        onClicked: () => powermenu.action(action),
    });

export const Header = () =>
    Widget.Box(
        { class_name: "header horizontal" },
        Widget.Box({
            vpack: "center",
            children: [
                Widget.Box([
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
        SysButton("shutdown"),
        SysButton("logout"),
        SysButton("lock")
    );
