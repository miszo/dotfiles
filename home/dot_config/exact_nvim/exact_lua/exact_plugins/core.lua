return {
  {
    'LazyVim/LazyVim',
    opts = function(_, opts)
      opts.colorscheme = { 'nightfly' }
      opts.icons = require('util.icons')
    end,
  },
}
