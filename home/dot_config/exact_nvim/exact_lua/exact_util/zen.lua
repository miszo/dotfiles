local M = {}

local function adjust_options_for_zen(config)
  config.options.multilines.enabled = not vim.g.is_zen_active

  return config
end

---@param win snacks.win
local function rerender_diagnostics(win)
  local diag = require('tiny-inline-diagnostic')
  local diag_renderer = require('tiny-inline-diagnostic.renderer')
  local config = adjust_options_for_zen(diag.config)

  diag_renderer.safe_render(config, win.buf)
end

---@param win snacks.win
function M.on_zen_open(win)
  vim.g.is_zen_active = true
  rerender_diagnostics(win)
end

---@param win snacks.win
function M.on_zen_close(win)
  vim.g.is_zen_active = false
  rerender_diagnostics(win)
end

function M.is_zen_active()
  return vim.g.is_zen_active
end

return M
