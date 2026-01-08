---@mode 'lazy'
---@type LazySpec[]
return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-mini/mini.icons',
      'catppuccin/nvim',
      'folke/noice.nvim',
      'SmiteshP/nvim-navic',
    },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = ' '
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,

    opts = function()
      local lualine_require = require('lualine_require')
      lualine_require.require = require

      local icons = UserConfig.icons
      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
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
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
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
            'sidekick',
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
                return require('noice').api.status.mode.get()
              end,
              cond = function()
                return package.loaded['noice'] and require('noice').api.status.mode.has()
              end,
              color = function()
                return { fg = Snacks.util.color('Constant') }
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
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
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

      return opts
    end,
    config = function(_, opts)
      require('lualine').setup(opts)
    end,
  },
}
