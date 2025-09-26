local M = {}

local function redraw_diagnostics()
  vim.diagnostic.hide()
  vim.diagnostic.show()
end

function M.on_zen_open()
  vim.g.is_zen_active = true
  redraw_diagnostics()
end

function M.on_zen_close()
  vim.g.is_zen_active = false
  redraw_diagnostics()
end

function M.is_zen_active()
  return vim.g.is_zen_active
end

return M
