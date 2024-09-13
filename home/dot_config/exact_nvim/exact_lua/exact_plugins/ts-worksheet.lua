return {
  {
    'typed-rocks/ts-worksheet-neovim',
    dependencies = { 'folke/which-key.nvim', 'echasnovski/mini.icons' },
    config = function(_, opts)
      require('tsw').setup(opts)

      local icons = require('mini.icons')
      require('which-key').add({ '<leader>W', group = 'TSWorksheet', icon = icons.get('extension', 'ts') })
      local function map(key, cmd, desc)
        vim.keymap.set({ 'n' }, '<leader>W' .. key, cmd, { desc = desc, silent = true, noremap = true })
      end
      map('n', '<cmd>Tsw rt=node show_variables=true show_order=true<cr>', 'Run Tsw with Node')
      map('d', '<cmd>Tsw rt=deno show_variables=true show_order=true<cr>', 'Run Tsw with Deno')
      map('b', '<cmd>Tsw rt=bun show_variables=true show_order=true<cr>', 'Run Tsw with Bun')
    end,
  },
}
