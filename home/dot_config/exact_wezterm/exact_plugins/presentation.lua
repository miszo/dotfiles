local wezterm = require('wezterm') --[[@as Wezterm]]

local M = {}

function M.setup(config)
  local presentation = wezterm.plugin.require('https://gitlab.com/xarvex/presentation.wez')

  presentation.apply_to_config(config, {
    font_size_multiplier = 1.8,
    presentation = {
      enabled = true,
      keybind = { key = 'p', mods = 'LEADER' },
    },
    presentation_full = {
      enabled = false,
    },
  })
end

return M
