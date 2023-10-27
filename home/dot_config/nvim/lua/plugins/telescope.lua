local Util = require('lazyvim.util')

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    keys = {
      { '<leader>fR', Util.telescope('resume'), desc = 'Resume' },
      {
        '<leader>sB',
        ':Telescope file_browser file_browser path=%:p:h=%:p:h<cr>',
        desc = 'Browse Files',
      },
    },
    config = function(_, opts)
      local telescope = require('telescope')
      telescope.setup(opts)
      telescope.load_extension('undo')
      telescope.load_extension('file_browser')
      telescope.load_extension('fzf')
    end,
  },
}
