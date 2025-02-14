local wezterm = require('wezterm') --[[@as Wezterm]]

local M = {}
---@param config Config
function M.setup(config)
  config.color_scheme = 'Catppuccin Mocha'

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

  config.default_cursor_style = 'SteadyBar'
  config.underline_thickness = 3
  config.cursor_thickness = 3
  config.underline_position = -6
  config.native_macos_fullscreen_mode = false
end

return M
