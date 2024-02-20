import css from "./style";
import gtk from "./gtk";
import lowBattery from "./battery";
import hyprland from "./hyprland";

export async function init() {
    try {
        gtk();
        css();
        lowBattery();
        hyprland();
    } catch (error) {
        logError(error);
    }
}
