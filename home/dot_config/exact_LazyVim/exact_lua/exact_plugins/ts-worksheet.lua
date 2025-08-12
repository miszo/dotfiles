---@module 'lazy'
---@type LazySpec[]
return {
  {
    'typed-rocks/ts-worksheet-neovim',
    config = function(_, opts)
      require('tsw').setup(opts)
      local function map(key, cmd, desc)
        vim.keymap.set({ 'n' }, '<leader>W' .. key, cmd, { desc = desc, silent = true, noremap = true })
      end
      map('n', '<cmd>Tsw rt=node show_variables=true show_order=true<cr>', 'Run Tsw with Node')
      map('d', '<cmd>Tsw rt=deno show_variables=true show_order=true<cr>', 'Run Tsw with Deno')
      map('b', '<cmd>Tsw rt=bun show_variables=true show_order=true<cr>', 'Run Tsw with Bun')
    end,
  },
  -- Which key
  {
    'folke/which-key.nvim',
    optional = true,
    dependencies = { 'echasnovski/mini.icons' },
    opts = {
      spec = {
        { '<leader>W', group = 'TSWorksheet', icon = require('mini.icons').get('extension', 'ts') },
      },
    },
  },
}
