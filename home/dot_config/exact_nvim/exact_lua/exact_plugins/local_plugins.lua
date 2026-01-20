---@module 'lazy'
---@type LazySpec[]
return {
  {
    dir = vim.g.local_plugins_path .. 'yank-filepath',
    config = function()
      require('local_plugins.yank-filepath.init').setup()
    end,
  },
  {
    dir = vim.g.local_plugins_path .. 'pkg-version',
    event = 'BufRead',
    config = function()
      require('local_plugins.pkg-version').setup({
        -- Custom config if needed
      })
    end,
    keys = {
      { '<leader>n', '', desc = '+Package Manager' },
      { '<leader>ns', function() require('local_plugins.pkg-version').show() end, desc = 'Show versions' },
      { '<leader>nh', function() require('local_plugins.pkg-version').hide() end, desc = 'Hide versions' },
      { '<leader>nn', function() require('local_plugins.pkg-version').toggle() end, desc = 'Toggle versions' },
      { '<leader>nr', function() require('local_plugins.pkg-version').refresh() end, desc = 'Refresh versions' },
      { '<leader>ni', function() require('local_plugins.pkg-version').install() end, desc = 'Install package' },
      { '<leader>nu', function() require('local_plugins.pkg-version').update() end, desc = 'Update package' },
      { '<leader>nd', function() require('local_plugins.pkg-version').delete() end, desc = 'Delete package' },
      { '<leader>nv', function() require('local_plugins.pkg-version').change_version() end, desc = 'Change version' },
      { '<leader>n?', function() require('local_plugins.pkg-version').show_package_manager_info() end, desc = 'Show package manager' },
    },
  },
}
