import options from "options";
import icons from "../lib/icons";

const pp = await Service.import("powerprofiles");

export default async function init() {
    const bat = await Service.import("battery");
    const { battery } = options.widgets.bar;

    bat.connect("notify::charging", ({charging}) => {
        if (charging && pp.active_profile === "power-saver") {
            pp.active_profile = "balanced";
        }
    })

    bat.connect("notify::percent", ({ percent, charging }) => {
        const low = battery.low.value;

        if ((percent === low || percent === Math.floor(low / 2)) && !charging) {
            Utils.notify({
                summary: "Battery is running low!",
                body: "plug in your PC",
                iconName: icons.battery.warning,
                urgency: "critical",
            });
        }
    });
}
