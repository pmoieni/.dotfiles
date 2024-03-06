import options from "options";
import Workspaces from "./buttons/Workspaces";
import Date from "./buttons/Date";
import SystemTray from "./buttons/SystemTray";
import PowerMenu from "./buttons/PowerMenu";
import Recorder from "./buttons/Recorder";
import Battery from "./buttons/Battery";
import Media from "./buttons/Media";
import Notifications from "./buttons/Notifications";
import QuickMenu from "./buttons/QuickMenu";

export default (monitor = 0) =>
    Widget.Window({
        monitor,
        name: "bar",
        className: "bar",
        exclusivity: "exclusive",
        anchor: options.widgets.bar.position
            .bind()
            .as((p) => [p, "right", "left"]),
        child: Widget.CenterBox({
            startWidget: Widget.Box({
                hexpand: true,
                children: [
                    Workspaces(),
                    Widget.Box({
                        expand: true,
                    }),
                    Media(),
                    Notifications(),
                ],
            }),
            centerWidget: Widget.Box({
                hpack: "center",
                children: [Date()],
            }),
            endWidget: Widget.Box({
                hexpand: true,
                children: [
                    Widget.Box({
                        expand: true,
                    }),
                    SystemTray(),
                    Recorder(),
                    QuickMenu(),
                    Battery(),
                    PowerMenu(),
                ],
            }),
        }),
    });
