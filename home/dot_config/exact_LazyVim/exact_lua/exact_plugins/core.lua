---@module 'lazy'
---@type LazySpec[]
return {
  {
    'LazyVim/LazyVim',
    opts = function(_, opts)
      opts.colorscheme = { 'catppuccin-mocha' }
      opts.icons = require('utils.icons').icons
    end,
  },
}
