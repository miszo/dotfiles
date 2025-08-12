---@module 'lazy'
---@type LazySpec[]
return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'BufReadPost',
    opts = {
      copilot_model = 'gpt-4.1',
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
          accept = false, -- handled by completion plugin
          next = '<M-]>',
          prev = '<M-[>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  -- add ai_accept action
  {
    'zbirenbaum/copilot.lua',
    opts = function()
      UserUtil.cmp.actions.ai_accept = function()
        if require('copilot.suggestion').is_visible() then
          UserUtil.cmp.create_undo()
          require('copilot.suggestion').accept()
          return true
        end
      end
    end,
  },
}
