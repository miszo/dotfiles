---@module "lazy"
---@type LazySpec[]
return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    opts = {
      model = vim.g.copilot_chat_model,
    },
  },
  {
    'zbirenbaum/copilot.lua',
    opts = function(_, opts)
      opts.copilot_model = vim.g.copilot_model
      -- Remove once https://github.com/LazyVim/LazyVim/pull/5900 is released
      require('copilot.api').status = require('copilot.status')
    end,
  },
}
