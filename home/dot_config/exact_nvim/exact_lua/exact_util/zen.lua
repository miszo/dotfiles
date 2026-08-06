local M = {}

function M.on_zen_open()
  vim.g.is_zen_active = true
  UserUtil.diagnostic.set_zen_active(true)
end

function M.on_zen_close()
  vim.g.is_zen_active = false
  UserUtil.diagnostic.set_zen_active(false)
end

function M.is_zen_active()
  return vim.g.is_zen_active
end

return M
