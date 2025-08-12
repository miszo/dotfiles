---@module 'lazy'
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
    opts = {
      copilot_model = vim.g.copilot_model,
    },
  },
}
