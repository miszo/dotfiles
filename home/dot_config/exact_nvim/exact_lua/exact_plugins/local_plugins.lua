---@module 'lazy'
---@type LazySpec[]
return {
  {
    dir = vim.g.local_plugins_path .. 'nvim-treesitter-shim',
    name = 'nvim-treesitter',
    lazy = true,
  },
  {
    dir = vim.g.local_plugins_path .. 'yank-filepath',
    config = function()
      require('local_plugins.yank-filepath.init').setup()
    end,
  },
}
