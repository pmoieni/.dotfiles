import { clock } from "lib/variables";

const format = Variable("%H:%M - %A %e.");
const time = Utils.derive([clock, format], (c, f) => c.format(f) || "");

export default () =>
    Widget.Button({
        className: "bar-date",
        onClicked: () => App.toggleWindow("datemenu"),
        child: Widget.Label({
            justification: "center",
            label: time.bind(),
        }),
    });
