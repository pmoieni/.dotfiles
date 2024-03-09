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
    },
    widget: { opacity: opt(90) },
    border: {
        width: opt(2),
        opacity: opt(95),
    },
    blur: opt(24),
    shadows: opt(true),
    padding: opt(8),
    spacing: opt(8),
    radius: opt(16),
    transition: opt(200),
    font: {
        size: opt(12),
        name: opt("Ubuntu Nerd Font"),
    },
    widgets: {
        bar: {
            position: opt<"top" | "bottom">("top"),
            battery: {
                low: opt(30),
            },
            workspaces: {
                workspaces: opt(5),
            },
            systray: {
                ignore: opt(["spotify-client"]),
            },
            media: {
                preferred: opt("spotify"),
                direction: opt<"left" | "right">("right"),
                length: opt(40),
            },
        },
        launcher: {
            width: opt(0),
            iconSize: opt(55),
            maxItem: opt(6),
            margin: opt(80),
            favorites: opt([
                [
                    "Firefox",
                    "Microsoft Edge",
                    "Tor Browser",
                    "Telegram Desktop",
                    "Slack",
                ],
                [
                    "wezterm",
                    "org.gnome.Nautilus",
                    "Obs studio",
                    "Spotify",
                    "GNU Image Manipulation Program",
                ],
            ]),
        },
        workspaces: {
            scale: opt(12),
            count: opt(5),
        },
        powermenu: {
            lock: opt("hyprlock"),
            sleep: opt("systemctl suspend"),
            reboot: opt("systemctl reboot"),
            logout: opt("killhypr"),
            shutdown: opt("shutdown now"),
            labels: opt(true),
        },
        quickmenu: {
            width: opt(400),
            position: opt<"left" | "center" | "right">("right"),
            media: {
                coverSize: opt(100),
            },
            networkSettings: opt("alacritty -e nmtui"),
        },
        datemenu: {
            position: opt<"left" | "center" | "right">("center"),
        },
        notifications: {
            width: opt(440),
            position: opt<Array<"top" | "bottom" | "left" | "right">>([
                "top",
                "right",
            ]),
            blacklist: opt(["Spotify"]),
        },
    },
    hyprland: {
        gaps: opt(2),
    },
});

globalThis["options"] = options;
export default options;
