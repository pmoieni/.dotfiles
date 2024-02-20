import css from "style/style";
import matugen from "./matugen";
import tmux from "./tmux";
import gtk from "../service/gtk";
import lowBattery from "../service/battery";
import swww from "./swww";

export async function init() {
    try {
        gtk();
        css();
        tmux();
        matugen();
        lowBattery();
        css();
        swww();
    } catch (error) {
        logError(error);
    }
}
