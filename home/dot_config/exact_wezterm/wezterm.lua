local wezterm = require('wezterm') --[[@as Wezterm]]
local config = wezterm.config_builder()
wezterm.log_info('reloading')

-- load the configuration files
require('config.mux').setup()
require('config.zen-mode').setup()
require('config.tabs').setup(config)
require('config.links').setup(config)
require('config.keys').setup(config)

-- load the plugins
require('plugins.presentation').setup(config)

config.color_scheme = 'Catppuccin Mocha'
config.scrollback_lines = 4000

config.default_workspace = 'main'

config.font = wezterm.font_with_fallback({
  { family = 'Monolisa Variable', harfbuzz_features = { 'calt=1', 'liga=1', 'ss02=1' } },
  'Apple Color Emoji',
  'Symbols Nerd Font Mono',
})
config.font_size = 14.0
config.line_height = 1.2

config.window_padding = {
  left = '1cell',
  right = '1cell',
  top = '0.5cell',
  bottom = 0,
}
config.window_decorations = 'RESIZE'
config.window_close_confirmation = 'AlwaysPrompt'

config.window_background_opacity = 0.9
config.macos_window_background_blur = 80

config.mouse_bindings = {
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

config.underline_thickness = 3
config.cursor_thickness = 3
config.underline_position = -6

config.term = 'xterm-kitty'
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'
config.enable_kitty_graphics = true
config.native_macos_fullscreen_mode = false
config.automatically_reload_config = true
config.default_cursor_style = 'SteadyBar'

return config
