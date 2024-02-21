import { type BarWidget } from "widget/bar/Bar";
import { opt, mkOptions } from "lib/option";

const options = mkOptions(OPTIONS, {
    theme: {
        dark: {
            primary: {
                bg: opt("#c4a7e7"),
                fg: opt("#191724"),
            },
            error: {
                bg: opt("#eb6f92"),
                fg: opt("#191724"),
            },
            bg: opt("#191724"),
            fg: opt("#e0def4"),
            widget: opt("#e0def4"),
            border: opt("#e0def4"),
        },
        light: {
            primary: {
                bg: opt("#907aa9"),
                fg: opt("#faf4ed"),
            },
            error: {
                bg: opt("#b4637a"),
                fg: opt("#faf4ed"),
            },
            bg: opt("#faf4ed"),
            fg: opt("#575279"),
            widget: opt("#575279"),
            border: opt("#575279"),
        },

        scheme: opt<"dark" | "light">("dark"),
        widget: { opacity: opt(94) },
        border: {
            width: opt(2),
            opacity: opt(96),
        },

        shadows: opt(false),
        padding: opt(8),
        spacing: opt(8),
        radius: opt(8),
    },

    transition: opt(200),

    font: {
        size: opt(12),
        name: opt("FiraCode Nerd Font"),
    },

    bar: {
        flatButtons: opt(true),
        position: opt<"top" | "bottom">("top"),
        corners: opt(true),
        layout: {
            start: opt<BarWidget[]>([
                "launcher",
                "workspaces",
                "expander",
                "media",
                "messages",
            ]),
            center: opt<BarWidget[]>(["date"]),
            end: opt<BarWidget[]>([
                "expander",
                "systray",
                "screenrecord",
                "system",
                "battery",
                "powermenu",
            ]),
        },
        launcher: {
            icon: {
                colored: opt(true),
                icon: opt("system-search-symbolic"),
            },
            label: {
                colored: opt(false),
                label: opt(" Applications"),
            },
            action: opt(() => App.toggleWindow("applauncher")),
        },
        date: {
            format: opt("%H:%M - %A %e."),
            action: opt(() => App.toggleWindow("datemenu")),
        },
        battery: {
            bar: opt<"hidden" | "regular" | "whole">("regular"),
            charging: opt("#00D787"),
            percentage: opt(true),
            blocks: opt(10),
            width: opt(70),
            low: opt(30),
        },
        workspaces: {
            workspaces: opt(5),
        },
        taskbar: {
            monochrome: opt(true),
            exclusive: opt(false),
        },
        messages: {
            action: opt(() => App.toggleWindow("datemenu")),
        },
        systray: {
            ignore: opt(["KDE Connect Indicator", "spotify-client"]),
        },
        media: {
            monochrome: opt(true),
            preferred: opt("spotify"),
            direction: opt<"left" | "right">("right"),
            length: opt(40),
        },
        powermenu: {
            monochrome: opt(false),
            action: opt(() => App.toggleWindow("powermenu")),
        },
    },

    applauncher: {
        iconSize: opt(62),
        width: opt(0),
        margin: opt(80),
        maxItem: opt(6),
        favorites: opt([
            "org.gnome.Nautilus",
            "org.gnome.Calendar",
            /*
      "obsidian",
      "discord",
      "spotify",
            */
        ]),
    },

    overview: {
        scale: opt(12),
        workspaces: opt(5),
        monochromeIcon: opt(true),
    },

    powermenu: {
        sleep: opt("systemctl suspend"),
        reboot: opt("systemctl reboot"),
        logout: opt("pkill Hyprland"),
        shutdown: opt("shutdown now"),
        layout: opt<"line" | "box">("line"),
        labels: opt(true),
    },

    quicksettings: {
        avatar: {
            image: opt(`/var/lib/AccountsService/icons/${Utils.USER}`),
            size: opt(70),
        },
        width: opt(380),
        position: opt<"left" | "center" | "right">("right"),
        networkSettings: opt("gtk-launch gnome-control-center"),
        media: {
            monochromeIcon: opt(true),
            coverSize: opt(100),
        },
        screenrecorder: {
            action: opt(() => App.toggleWindow("quicksettings")),
        },
    },

    datemenu: {
        position: opt<"left" | "center" | "right">("center"),
    },

    osd: {
        progress: {
            vertical: opt(false),
            pack: {
                h: opt<"start" | "center" | "end">("center"),
                v: opt<"start" | "center" | "end">("end"),
            },
        },
        microphone: {
            pack: {
                h: opt<"start" | "center" | "end">("center"),
                v: opt<"start" | "center" | "end">("end"),
            },
        },
    },

    notifications: {
        position: opt<Array<"top" | "bottom" | "left" | "right">>([
            "top",
            "right",
        ]),
        blacklist: opt(["Spotify"]),
        width: opt(440),
    },

    hyprland: {
        blur: opt<"*" | Array<string>>(["powermenu", "verification"]),
        alpha: opt(0.3),
        gaps: opt(2),
        inactiveBorder: opt("333333ff"),
    },
});

globalThis["options"] = options;
export default options;
