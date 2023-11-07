local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.font = wezterm.font_with_fallback({ "FiraCode Nerd Font", "Noto Sans" })
config.font_size = 11.0

config.window_background_opacity = 0.8

config.color_scheme = "rose-pine"

config.default_prog = { "/usr/bin/tmux", "new-session", "-A" }

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

return config
