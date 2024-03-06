import options from "options";
const { messageAsync } = await Service.import("hyprland");

const { hyprland } = options;
const {
    dark: {
        primary: { bg: darkActive },
    },
    light: {
        primary: { bg: lightActive },
    },
    scheme,
} = options.theme;
const {
    spacing,
    radius,
    border: { width },
    blur,
    shadows,
} = options;

const deps = [
    "hyprland",
    spacing.id,
    radius.id,
    width.id,
    blur.id,
    shadows.id,
    darkActive.id,
    lightActive.id,
    scheme.id,
];

export default function init() {
    options.handler(deps, setupHyprland);
    setupHyprland();
}

function activeBorder() {
    const color =
        scheme.value === "dark" ? darkActive.value : lightActive.value;

    return color.replace("#", "");
}

function sendBatch(batch: string[]) {
    const cmd = batch
        .filter((x) => !!x)
        .map((x) => `keyword ${x}`)
        .join("; ");

    return messageAsync(`[[BATCH]]/${cmd}`);
}

async function setupHyprland() {
    const wm_gaps = Math.floor(hyprland.gaps.value * spacing.value);

    sendBatch([
        `general:border_size ${width.value}`,
        `general:gaps_out ${Math.floor(wm_gaps / 2)}`,
        `general:gaps_in ${Math.floor(wm_gaps / 4)}`,
        `general:col.active_border rgba(${activeBorder()}ff)`,
        `decoration:rounding ${Math.floor(radius.value / 2)}`,
        `decoration:drop_shadow ${shadows.value ? "yes" : "no"}`,
    ]);

    await sendBatch(App.windows.map(({ name }) => `layerrule unset, ${name}`));

    if (blur.value > 0) {
        sendBatch(
            App.windows.flatMap(({ name }) => [
                `layerrule unset, ${name}`,
                `layerrule blur, ${name}`,
                `layerrule ignorealpha ${
                    /* based on shadow color */ 0.29
                }, ${name}`,
            ])
        );
    }
}
