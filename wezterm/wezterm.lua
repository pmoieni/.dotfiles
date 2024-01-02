local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.font = wezterm.font_with_fallback({ "FiraCode Nerd Font", "Noto Sans" })
config.font_size = 12.0

config.window_background_opacity = 0.8

config.color_scheme = "rose-pine"

config.default_prog = { "fish", "-l" }

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.enable_tab_bar = false

config.set_environment_variables = {
    TERM = "xterm-256color",
}

config.leader = { key = 'a', mods = 'ALT', timeout_milliseconds = 1000 }

config.keys = {
    {
        key = '|',
        mods = 'LEADER|SHIFT',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = '-',
        mods = 'LEADER',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 't',
        mods = 'LEADER',
        action = wezterm.action.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = '[',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(-1),
    },
    {
        key = ']',
        mods = 'LEADER',
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        key = 'r',
        mods = 'LEADER',
        action = wezterm.action.ActivateKeyTable {
            name = 'resize_pane',
            one_shot = false,
        },
    },
    {
        key = 'h',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Left'
    },
    {
        key = 'j',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Down'
    },
    {
        key = 'k',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Up'
    },
    {
        key = 'l',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Right'
    },
}

config.key_tables = {
    resize_pane = {
        {
            key = 'h',
            action = wezterm.action.AdjustPaneSize { 'Left', 1 }
        },
        {
            key = 'j',
            action = wezterm.action.AdjustPaneSize { 'Down', 1 }
        },
        {
            key = 'k',
            action = wezterm.action.AdjustPaneSize { 'Up', 1 }
        },
        {
            key = 'l',
            action = wezterm.action.AdjustPaneSize { 'Right', 1 }
        },
        {
            key = 'Escape',
            action = 'PopKeyTable'
        },
    },
}

return config
