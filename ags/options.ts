import { type BarWidget } from "widget/bar/Bar";
import { opt, mkOptions } from "lib/option";
import icons from "lib/icons";
import { distro } from "lib/variables";
import { icon } from "lib/utils";

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

        blur: opt(25),
        shadows: opt(true),
        padding: opt(8),
        spacing: opt(8),
        radius: opt(16),
    },

    transition: opt(200),

    font: {
        size: opt(12),
        name: opt("FiraCode Nerd Font"),
    },

    bar: {
        flatButtons: opt(true),
        position: opt<"top" | "bottom">("top"),
        corners: opt(false),
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
                icon: opt(icon(distro, icons.ui.search)),
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
            blocks: opt(7),
            width: opt(50),
            low: opt(30),
        },
        workspaces: {
            workspaces: opt(5),
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
            [
                "org.gnome.Nautilus",
                "Firefox",
                "Microsoft Edge",
                "Tor Browser",
                "Telegram Desktop",
            ],
            [
                "Visual Studio Code",
                "wezterm",
                "Obs studio",
                "Spotify",
                "GNU Image Manipulation Program",
            ],
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
        logout: opt("killhypr"),
        shutdown: opt("shutdown now"),
        layout: opt<"line" | "box">("line"),
        labels: opt(true),
    },

    quicksettings: {
        width: opt(350),
        position: opt<"left" | "center" | "right">("right"),
        networkSettings: opt("nmtui"),
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
        gaps: opt(2),
        inactiveBorder: opt("6e6a86ff"),
    },
});

globalThis["options"] = options;
export default options;
