return {
  {
    'axieax/urlview.nvim',
    config = function()
      require('urlview').setup({
        default_picker = 'native',
        default_action = 'system',
      })
      vim.keymap.set('n', '<leader>bu', '<Cmd>UrlView<CR>', { desc = 'View buffer URLs' })
    end,
  },
}
