return {
  {
    dir = vim.g.local_plugins_path .. 'copy-filepath',
    config = function()
      require('local_plugins.copy-filepath').setup()
    end,
  },
}
