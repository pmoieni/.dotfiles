import options from "options";
import icons from "../lib/icons";

export default async function init() {
    const bat = await Service.import("battery");
    const { battery } = options.bar;
    bat.connect("notify::percent", ({ percent, charging }) => {
        if (
            percent !== battery.low.value ||
            percent !== battery.low.value / 2 ||
            !charging
        )
            return;

        Utils.notify({
            summary: `${percent}% Battery Percentage`,
            iconName: icons.battery.warning,
            urgency: "critical",
        });
    });
}
