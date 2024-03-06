import NotificationColumn from "./NotificationColumn";
import options from "options";
import PopupWindow from "widgets/PopupWindow";

const { bar, datemenu } = options.widgets;
const pos = bar.position.bind();
const layout = Utils.derive(
    [bar.position, datemenu.position],
    (bar, qs) => `${bar}-${qs}` as const
);

const Settings = () =>
    Widget.Box({
        class_name: "datemenu horizontal",
        vexpand: false,
        children: [NotificationColumn(), Widget.Separator({ orientation: 1 })],
    });

export default () =>
    PopupWindow({
        name: "datemenu",
        exclusivity: "exclusive",
        transition: pos.as((pos) =>
            pos === "top" ? "slide_down" : "slide_up"
        ),
        layout: layout.value,
        child: Settings(),
    });
