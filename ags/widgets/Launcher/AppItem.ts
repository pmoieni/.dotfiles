import { type Application } from "types/service/applications";
import options from "options";
import { launchApp, icon } from "lib/utils";
import icons from "lib/icons";

const { iconSize } = options.widgets.launcher.apps;

export const QuickButton = (app: Application) =>
    Widget.Button({
        hexpand: true,
        tooltip_text: app.name,
        onClicked: () => {
            App.closeWindow("launcher");
            launchApp(app);
        },
        child: Widget.Icon({
            size: iconSize.bind(),
            icon: icon(app.icon_name, icons.fallback.executable),
        }),
    });

export const AppItem = (app: Application) => {
    const title = Widget.Label({
        className: "title",
        label: app.name,
        hexpand: true,
        xalign: 0,
        vpack: "center",
        truncate: "end",
    });

    const description = Widget.Label({
        className: "description",
        label: app.description || "",
        hexpand: true,
        wrap: true,
        maxWidthChars: 30,
        xalign: 0,
        justification: "left",
        vpack: "center",
    });

    const appicon = Widget.Icon({
        icon: icon(app.icon_name, icons.fallback.executable),
        size: iconSize.bind(),
    });

    const textBox = Widget.Box({
        vertical: true,
        vpack: "center",
        children: app.description ? [title, description] : [title],
    });

    return Widget.Button({
        className: "app-item",
        attribute: { app },
        child: Widget.Box({
            children: [appicon, textBox],
        }),
        on_clicked: () => {
            App.closeWindow("launcher");
            launchApp(app);
        },
    });
};
