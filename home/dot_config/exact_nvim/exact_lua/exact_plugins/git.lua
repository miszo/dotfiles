return {
  {
    'tpope/vim-fugitive',
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = function(_, opts)
      opts.current_line_blame = false
      opts.current_line_blame_opts = {
        delay = 300,
      }
    end,
    config = function(_, opts)
      require('gitsigns').setup(opts)

      vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { desc = 'Preview hunk' })
      vim.keymap.set(
        'n',
        '<leader>gt',
        ':Gitsigns toggle_current_line_blame<CR>',
        { desc = 'Toggle current line blame' }
      )
    end,
  },
}
