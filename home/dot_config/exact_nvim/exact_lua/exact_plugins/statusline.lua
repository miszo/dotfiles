---@mode 'lazy'
---@type LazySpec[]
return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      'echasnovski/mini.icons',
      'catppuccin/nvim',
      'folke/noice.nvim',
      'SmiteshP/nvim-navic',
    },
    opts = function()
      return {
        options = {
          globalstatus = true,
          theme = 'catppuccin',
          icons_enabled = true,
          component_separators = { left = '', right = ' ' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = { 'snacks_dashboard' },
        },
        extensions = { 'lazy' },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch' },
          lualine_c = {
            {
              'diagnostics',
              symbols = {
                error = UserConfig.icons.diagnostics.Error,
                warn = UserConfig.icons.diagnostics.Warn,
                info = UserConfig.icons.diagnostics.Info,
                hint = UserConfig.icons.diagnostics.Hint,
              },
            },
            { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
            {
              'filename',
              file_status = false,
              newfile_status = true,
              path = 1,
              fmt = UserUtil.statusline.filename_fmt,
              color = UserUtil.statusline.filename_color,
            },
            { 'navic', color_correction = 'dynamic' },
          },
          lualine_x = {
            'copilot',
            UserUtil.statusline.mcphub(),
            'codecompanion',
            {
              function()
                return require('noice').api.status.command.get()
              end,
              cond = function()
                return package.loaded['noice'] and require('noice').api.status.command.has()
              end,
              color = function()
                return { fg = Snacks.util.color('Statement') }
              end,
            },
            {
              function()
                return UserConfig.icons.statusline.debugger .. require('dap').status()
              end,
              cond = function()
                return package.loaded['dap'] and require('dap').status() ~= ''
              end,
              color = function()
                return { fg = Snacks.util.color('Debug') }
              end,
            },
            {
              require('lazy.status').updates,
              cond = require('lazy.status').has_updates,
              color = function()
                return { fg = Snacks.util.color('Special') }
              end,
            },
            {
              'diff',
              symbols = {
                added = UserConfig.icons.git.added,
                modified = UserConfig.icons.git.modified,
                removed = UserConfig.icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      }
    end,
    config = function(_, opts)
      require('lualine').setup(opts)
    end,
  },
}
