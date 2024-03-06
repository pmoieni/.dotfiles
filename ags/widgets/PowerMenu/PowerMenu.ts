import powermenu, { type Action } from "service/powermenu";
import icons from "lib/icons";
import options from "options";
import type Gtk from "gi://Gtk?version=3.0";
import PopupWindow from "widgets/PopupWindow";

const { labels } = options.widgets.powermenu;

const SysButton = (action: Action, label: string) =>
    Widget.Button({
        onClicked: () => powermenu.action(action),
        child: Widget.Box({
            vertical: true,
            className: "system-button",
            children: [
                Widget.Icon(icons.powermenu[action]),
                Widget.Label({
                    label,
                    visible: labels.bind(),
                }),
            ],
        }),
    });

export default () =>
    PopupWindow({
        name: "powermenu",
        transition: "crossfade",
        setup: (w) =>
            w.keybind(["SUPER", "SHIFT"], "E", () => {
                App.toggleWindow("powermenu");
            }),
        keymode: "on-demand",
        child: Widget.Box<Gtk.Widget>({
            className: "powermenu horizontal",
            children: [
                SysButton("shutdown", "Shutdown"),
                SysButton("logout", "Log Out"),
                SysButton("reboot", "Reboot"),
                SysButton("sleep", "Sleep"),
            ],
        }),
    });
