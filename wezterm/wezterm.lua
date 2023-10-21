local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

local mux = wezterm.mux

wezterm.on('gui-attached', function(domain)
	-- maximize all displayed windows on startup
	local workspace = mux.get_active_workspace()
	for _, window in ipairs(mux.all_windows()) do
		if window:get_workspace() == workspace then
			window:gui_window():maximize()
		end
	end
end)

config.font = wezterm.font('FiraCode Nerd Font')
config.font_size = 11.0

config.window_background_opacity = 0.9

config.color_scheme = 'Catppuccin Mocha'

config.default_prog = { '/usr/bin/fish', '-l', '-c', 'tmux new-session -A' }

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.enable_tab_bar = false

config.disable_default_key_bindings = true

config.set_environment_variables = {
	TERM = 'xterm-256color'
}


return config
