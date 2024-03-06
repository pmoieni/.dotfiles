import { sh, range } from "lib/utils";
import options from "options";

const hyprland = await Service.import("hyprland");

const dispatch = (arg: string | number) => {
    sh(`hyprctl dispatch workspace ${arg}`);
};

const Workspaces = (ws: number) =>
    Widget.Box({
        children: range(ws).map((i) =>
            Widget.Label({
                attribute: i,
                vpack: "center",
                label: `${i}`,
                setup: (self) =>
                    self.hook(hyprland, () => {
                        self.toggleClassName(
                            "active",
                            hyprland.active.workspace.id === i
                        );
                        self.toggleClassName(
                            "occupied",
                            (hyprland.getWorkspace(i)?.windows || 0) > 0
                        );
                    }),
            })
        ),
        setup: (self) => {
            if (ws === 0) {
                self.hook(hyprland.active.workspace, () =>
                    self.children.map((btn) => {
                        btn.visible = hyprland.workspaces.some(
                            (ws) => ws.id === btn.attribute
                        );
                    })
                );
            }
        },
    });

export default () =>
    Widget.Button({
        className: "bar-workspaces",
        onScrollUp: () => dispatch("m+1"),
        onScrollDown: () => dispatch("m-1"),
        onClicked: () => App.toggleWindow("workspaces"),
        child: options.widgets.bar.workspaces.workspaces.bind().as(Workspaces),
    });
