local wezterm = require('wezterm') --[[@as Wezterm]]
local config = wezterm.config_builder()
wezterm.log_info('reloading')

-- load the configuration files
require('config.theme').setup(config)
require('config.mux').setup()
require('config.zen-mode').setup()
require('config.tabs').setup(config)
require('config.links').setup(config)
require('config.keys').setup(config)

-- load the plugins
require('plugins.presentation').setup(config)

config.scrollback_lines = 4000

config.default_workspace = 'main'

config.mouse_bindings = {
  -- Cmd-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

config.term = 'wezterm'
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'
config.enable_kitty_graphics = true
config.automatically_reload_config = true

return config
