local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Gruvbox dark, medium (base16)'
config.font = wezterm.font 'Cascadia Code'

config.enable_tab_bar = false

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.window_close_confirmation = 'NeverPrompt'

return config
