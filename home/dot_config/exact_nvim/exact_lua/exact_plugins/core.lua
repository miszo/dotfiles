return {
  {
    'LazyVim/LazyVim',
    opts = function(_, opts)
      opts.colorscheme = { 'catppuccin-mocha' }
      opts.icons = require('util.icons')
    end,
  },
}
