local wezterm = require('wezterm') --[[@as Wezterm]]
local mux = wezterm.mux

local M = {}

function M.setup()
  wezterm.on('gui-startup', function()
    local _, _, window = mux.spawn_window({})
    window:gui_window():maximize()
  end)
end

return M
