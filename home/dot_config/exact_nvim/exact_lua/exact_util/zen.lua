local M = {}

---@param win snacks.win
function M.on_zen_open(win)
  UserUtil.diagnostics.rerender(win.buf, false)
end

---@param win snacks.win
function M.on_zen_close(win)
  UserUtil.diagnostics.rerender(win.buf, true)
end

return M
