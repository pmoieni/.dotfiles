import { type Stream } from "types/service/audio";
import { Arrow, Menu } from "../ToggleButton";
import { dependencies, icon, sh } from "lib/utils";
import icons from "lib/icons.js";
const audio = await Service.import("audio");

const VolumeSlider = (type: "speaker" | "microphone" = "speaker") =>
    Widget.Slider({
        hexpand: true,
        draw_value: false,
        on_change: ({ value, dragging }) =>
            dragging && (audio[type].volume = value),
        value: audio[type].bind("volume"),
    });

const AudioIndicator = () =>
    Widget.Button({
        vpack: "center",
        on_clicked: () => (audio.speaker.is_muted = !audio.speaker.is_muted),
        child: Widget.Icon({
            icon: audio.speaker.bind("volume").as((vol) => {
                const { muted, low, medium, high, overamplified } =
                    icons.audio.volume;
                const cons = [
                    [101, overamplified],
                    [67, high],
                    [34, medium],
                    [1, low],
                    [0, muted],
                ] as const;
                const icon = cons.find(([n]) => n <= vol * 100)?.[1] || "";
                return audio.speaker.is_muted ? muted : icon;
            }),
        }),
        tooltipText: audio.speaker
            .bind("volume")
            .as((vol) => `Volume: ${Math.floor(vol * 100)}%`),
    });

export const Audio = () =>
    Widget.Box({
        class_name: "volume",
        children: [
            AudioIndicator(),
            VolumeSlider("speaker"),
            Widget.Box({
                vpack: "center",
                child: Arrow("sink-selector"),
            }),
            Widget.Box({
                vpack: "center",
                child: Arrow("app-mixer"),
                visible: audio.bind("apps").as((a) => a.length > 0),
            }),
        ],
    });

const MicrophoneIndicator = () =>
    Widget.Button({
        vpack: "center",
        on_clicked: () =>
            (audio.microphone.is_muted = !audio.microphone.is_muted),
        child: Widget.Icon({
            icon: audio.microphone.bind("volume").as((vol) => {
                const { muted, low, medium, high } = icons.audio.mic;
                const cons = [
                    [67, high],
                    [34, medium],
                    [1, low],
                    [0, muted],
                ] as const;
                const icon = cons.find(([n]) => n <= vol * 100)?.[1] || "";
                return audio.microphone.is_muted ? muted : icon;
            }),
        }),
        tooltipText: audio.microphone
            .bind("volume")
            .as((vol) => `Volume: ${Math.floor(vol * 100)}%`),
    });

export const Microphone = () =>
    Widget.Box({
        class_name: "volume",
        // TODO: why recorders is null ?
        // visible: audio.bind("recorders").as((a) => a.length > 0),
        visible: !!audio.bind("microphone"),
        children: [MicrophoneIndicator(), VolumeSlider("microphone")],
    });

const MixerItem = (stream: Stream) =>
    Widget.Box(
        {
            hexpand: true,
            class_name: "mixer-item horizontal",
        },
        Widget.Icon({
            tooltip_text: stream.bind("name").as((n) => n || ""),
            icon: stream.bind("name").as((n) => {
                return Utils.lookUpIcon(n || "")
                    ? n || ""
                    : icons.fallback.audio;
            }),
        }),
        Widget.Box(
            { vertical: true },
            Widget.Label({
                xalign: 0,
                truncate: "end",
                max_width_chars: 28,
                label: stream.bind("description").as((d) => d || ""),
            }),
            Widget.Slider({
                hexpand: true,
                draw_value: false,
                value: stream.bind("volume"),
                on_change: ({ value }) => (stream.volume = value),
            })
        )
    );

const SinkItem = (stream: Stream) =>
    Widget.Button({
        hexpand: true,
        on_clicked: () => (audio.speaker = stream),
        child: Widget.Box({
            children: [
                Widget.Icon({
                    icon: icon(stream.icon_name || "", icons.fallback.audio),
                    tooltip_text: stream.icon_name || "",
                }),
                Widget.Label(
                    (stream.description || "").split(" ").slice(0, 4).join(" ")
                ),
                Widget.Icon({
                    icon: icons.ui.tick,
                    hexpand: true,
                    hpack: "end",
                    visible: audio.speaker
                        .bind("stream")
                        .as((s) => s === stream.stream),
                }),
            ],
        }),
    });

const SettingsButton = () =>
    Widget.Button({
        on_clicked: () => {
            if (dependencies("pavucontrol")) sh("pavucontrol");
        },
        hexpand: true,
        child: Widget.Box({
            children: [
                Widget.Icon(icons.ui.settings),
                Widget.Label("Settings"),
            ],
        }),
    });

export const AppMixer = () =>
    Menu({
        name: "app-mixer",
        icon: icons.audio.mixer,
        title: "App Mixer",
        content: [
            Widget.Box({
                vertical: true,
                class_name: "vertical mixer-item-box",
                children: audio.bind("apps").as((a) => a.map(MixerItem)),
            }),
            Widget.Separator(),
            SettingsButton(),
        ],
    });

export const SinkSelector = () =>
    Menu({
        name: "sink-selector",
        icon: icons.audio.type.headset,
        title: "Sink Selector",
        content: [
            Widget.Box({
                vertical: true,
                children: audio.bind("speakers").as((a) => a.map(SinkItem)),
            }),
            Widget.Separator(),
            SettingsButton(),
        ],
    });
