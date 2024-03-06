import icons from "lib/icons";
import options from "options";

const battery = await Service.import("battery");
const { low } = options.widgets.bar.battery;

const Indicator = () =>
    Widget.Icon({
        setup: (self) =>
            self.hook(battery, () => {
                self.icon =
                    battery.charging || battery.charged
                        ? icons.battery.charging
                        : battery.icon_name;
            }),
    });

export default () =>
    Widget.Button({
        className: "bar-battery",
        visible: battery.bind("available"),
        child: Widget.Box({
            children: [
                Indicator(),
                Widget.Label({
                    label: battery.bind("percent").as((p) => `${p}%`),
                }),
            ],
        }),
        setup: (self) =>
            self.hook(battery, (w) => {
                w.toggleClassName(
                    "charging",
                    battery.charging || battery.charged
                );
                w.toggleClassName("low", battery.percent < low.value);
            }),
    });
