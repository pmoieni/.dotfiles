import BatteryBar from "./buttons/BatteryBar";
import Date from "./buttons/Date";
import Launcher from "./buttons/Launcher";
import Media from "./buttons/Media";
import PowerMenu from "./buttons/PowerMenu";
import SysTray from "./buttons/SysTray";
import SystemIndicators from "./buttons/SystemIndicators";
import Workspaces from "./buttons/Workspaces";
import ScreenRecord from "./buttons/ScreenRecord";
import Messages from "./buttons/Messages";
import options from "options";

const { start, center, end } = options.bar.layout;
const pos = options.bar.position.bind();

export type BarWidget = keyof typeof widget;

const widget = {
    battery: BatteryBar,
    date: Date,
    launcher: Launcher,
    media: Media,
    powermenu: PowerMenu,
    systray: SysTray,
    system: SystemIndicators,
    workspaces: Workspaces,
    screenrecord: ScreenRecord,
    messages: Messages,
    expander: () => Widget.Box({ expand: true }),
};

export default (monitor: number = 0) =>
    Widget.Window({
        monitor,
        class_name: "bar",
        name: "bar",
        exclusivity: "exclusive",
        anchor: pos.as((pos) => [pos, "right", "left"]),
        child: Widget.CenterBox({
            css: "min-width: 2px; min-height: 2px;",
            startWidget: Widget.Box({
                hexpand: true,
                children: start.bind().as((s) => s.map((w) => widget[w]())),
            }),
            centerWidget: Widget.Box({
                hpack: "center",
                children: center.bind().as((c) => c.map((w) => widget[w]())),
            }),
            endWidget: Widget.Box({
                hexpand: true,
                children: end.bind().as((e) => e.map((w) => widget[w]())),
            }),
        }),
    });
