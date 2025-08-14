local M = {}

local copilot_client = require('copilot.client')
local copilot_status = require('copilot.status')

local is_current_buffer_attached = function()
  return copilot_client.buf_is_attached(vim.api.nvim_get_current_buf())
end

---Check if copilot is enabled
---@return boolean
M.is_enabled = function()
  if copilot_client.is_disabled() then
    return false
  end

  if not is_current_buffer_attached() then
    return false
  end

  return true
end

---Check if copilot is online
---@return boolean
M.is_error = function()
  if copilot_client.is_disabled() then
    return false
  end

  if not is_current_buffer_attached() then
    return false
  end

  local data = copilot_status.data.status
  if data == 'Warning' then
    return true
  end

  return false
end

return M
