-- Notification helper with consistent title
local M = {}

---Show notification with plugin title
---@param msg string Message
---@param level number? vim.log.levels (default: INFO)
function M.notify(msg, level)
  local config = require('local_plugins.pkg-version.config')
  vim.notify(msg, level or vim.log.levels.INFO, { title = config.options.notification_title })
end

return M
