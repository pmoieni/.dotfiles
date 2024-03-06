import Workspace from "./Workspace";
import options from "options";
import { range } from "lib/utils";
import PopupWindow from "widgets/PopupWindow";

const hyprland = await Service.import("hyprland");

const Workspaces = (ws: number) =>
    Widget.Box({
        class_name: "workspaces horizontal",
        children:
            ws > 0
                ? range(ws).map(Workspace)
                : hyprland.workspaces
                      .map(({ id }) => Workspace(id))
                      .sort((a, b) => a.attribute.id - b.attribute.id),

        setup: (w) => {
            if (ws > 0) return;

            w.hook(
                hyprland,
                (w, id?: string) => {
                    if (id === undefined) return;

                    w.children = w.children.filter(
                        (ch) => ch.attribute.id !== Number(id)
                    );
                },
                "workspace-removed"
            );
            w.hook(
                hyprland,
                (w, id?: string) => {
                    if (id === undefined) return;

                    w.children = [...w.children, Workspace(Number(id))].sort(
                        (a, b) => a.attribute.id - b.attribute.id
                    );
                },
                "workspace-added"
            );
        },
    });

export default () =>
    PopupWindow({
        name: "workspaces",
        setup: (w) =>
            w.keybind(["SUPER"], "D", () => {
                App.toggleWindow("workspaces");
            }),
        keymode: "on-demand",
        layout: "center",
        child: options.widgets.workspaces.count.bind().as(Workspaces),
    });
