local M = {}

---Get icon for operation title
---@param title string Operation title
---@return string icon
local function get_icon(title)
  local icons = UserConfig.icons.package
  
  local lower = title:lower()
  if lower:match('install') then
    return icons.installing
  elseif lower:match('updat') then
    return icons.updating
  elseif lower:match('delet') or lower:match('remov') then
    return icons.deleting
  elseif lower:match('fetch') then
    return icons.fetching
  end
  
  return ''
end

---Start progress notification
---@param title string Operation title (e.g., "Installing", "Updating")
---@param message string? Optional message
---@return number token Progress token for updates
function M.start(title, message)
  local config = require('local_plugins.pkg-version.config')
  local icon = get_icon(title)
  local msg = icon .. title
  if message then
    msg = msg .. ': ' .. message
  end
  vim.notify(msg, vim.log.levels.INFO, { title = config.options.notification_title })
  return os.time() -- Return simple timestamp as token
end

---Complete progress (success)
---@param token number Progress token from start()
---@param message string? Completion message
function M.done(token, message)
  if message then
    local config = require('local_plugins.pkg-version.config')
    vim.notify(UserConfig.icons.package.success .. message, vim.log.levels.INFO, { title = config.options.notification_title })
  end
end

---Cancel progress (error or cancellation)
---@param token number Progress token from start()
---@param message string? Cancellation message
function M.cancel(token, message)
  if message then
    local config = require('local_plugins.pkg-version.config')
    vim.notify(UserConfig.icons.package.error .. message, vim.log.levels.ERROR, { title = config.options.notification_title })
  end
end

return M
