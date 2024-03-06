import icons from "lib/icons";

export default () =>
    Widget.Button({
        className: "bar-powermenu",
        onClicked: () => App.toggleWindow("powermenu"),
        child: Widget.Icon(icons.powermenu.shutdown),
    });
