local M = {}

-- Track if user has explicitly triggered an action
M.user_action_pending = false

---Set user action pending state
---@param pending boolean
M.set_user_action = function(pending)
  M.user_action_pending = pending
  -- Auto-refresh lualine
  vim.schedule(function()
    require('lualine').refresh({ place = { 'statusline' } })
  end)
end

---Check if sidekick is working on a user-triggered action
---@return boolean
M.is_working = function()
  return M.user_action_pending
end

---Reset user action state
M.reset = function()
  M.user_action_pending = false
end

return M
