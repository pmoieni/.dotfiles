import { type TrayItem } from "types/service/systemtray";
import options from "options";
import Gdk from "gi://Gdk?version=3.0";

const systemtray = await Service.import("systemtray");
const { ignore } = options.widgets.bar.systray;

const SysTrayItem = (item: TrayItem) =>
    Widget.Button({
        className: "bar-tray-item",
        child: Widget.Icon({ icon: item.bind("icon") }),
        tooltip_markup: item.bind("tooltip_markup"),
        setup: (self) => {
            const menu = item.menu;
            if (!menu) return;

            const id = item.menu?.connect("popped-up", () => {
                self.toggleClassName("active");
                menu.connect("notify::visible", () => {
                    self.toggleClassName("active", menu.visible);
                });
                menu.disconnect(id!);
            });

            if (id) self.connect("destroy", () => item.menu?.disconnect(id));
        },
        onClicked: (self) =>
            item.menu?.popup_at_widget(
                self,
                Gdk.Gravity.SOUTH,
                Gdk.Gravity.NORTH,
                null
            ),
    });

export default () =>
    Widget.Box({ className: "bar-tray" }).bind(
        "children",
        systemtray,
        "items",
        (i) => i.filter(({ id }) => !ignore.value.includes(id)).map(SysTrayItem)
    );
