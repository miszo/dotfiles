local M = {}

local CREATE_UNDO = vim.api.nvim_replace_termcodes('<c-G>u', true, true, true)

---@alias util.cmp.Action fun():boolean?
---@type table<string, util.cmp.Action>
M.actions = {
  -- Sidekick Next Edit Suggestions
  sidekick_nes = function()
    local ok, sidekick = pcall(require, 'sidekick')
    if ok and sidekick.nes_jump_or_apply then
      return sidekick.nes_jump_or_apply()
    end
  end,
  -- Native Snippets
  snippet_forward = function()
    if vim.snippet.active({ direction = 1 }) then
      vim.schedule(function()
        vim.snippet.jump(1)
      end)
      return true
    end
  end,
  snippet_stop = function()
    if vim.snippet then
      vim.snippet.stop()
    end
  end,
}

---@param actions string[]
---@param fallback? string|fun()
function M.map(actions, fallback)
  return function()
    for _, name in ipairs(actions) do
      if M.actions[name] then
        local ret = M.actions[name]()
        if ret then
          return true
        end
      end
    end
    return type(fallback) == 'function' and fallback() or fallback
  end
end

function M.create_undo()
  if vim.api.nvim_get_mode().mode == 'i' then
    vim.api.nvim_feedkeys(CREATE_UNDO, 'n', false)
  end
end

return M
