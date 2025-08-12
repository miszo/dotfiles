---@module 'lazy'
---@type LazySpec[]
return {
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    ---@param _ LazyPlugin
    ---@param opts CatppuccinOptions
    config = function(_, opts)
      local colors = require('catppuccin.palettes').get_palette()
      opts.flavour = 'mocha'
      opts.transparent_background = false
      opts.styles = opts.styles or {}
      opts.styles = vim.tbl_deep_extend('force', opts.styles, {
        comments = { 'italic' },
        conditionals = {},
        functions = { 'italic' },
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        operators = {},
        types = {},
      })

      opts.integrations = opts.integrations or {}
      opts.integrations = vim.tbl_deep_extend('force', opts.integrations, {
        blink_cmp = true,
        cmp = true,
        fidget = true,
        grug_far = true,
        harpoon = true,
        mason = true,
        neotree = true,
        navic = {
          enabled = true,
          custom_bg = colors.mantle,
        },
        render_markdown = true,
        snacks = true,
        which_key = true,
      })

      opts.highlight_overrides = opts.highlight_overrides or {}
      opts.highlight_overrides = {
        all = function(c)
          return {
            PackageInfoOutdatedVersion = { fg = c.peach },
            PackageInfoUpToDateVersion = { fg = c.green },
            PackageInfoInErrorVersion = { fg = c.red },
            SnacksIndent = { link = 'Whitespace' },
            SnacksIndentScope = { fg = c.text },
            SnacksPickerGitStatusIgnored = { link = 'NonText' },
            NormalFloat = { bg = c.base },
            FloatBorder = { bg = c.base },
            FloatTitle = { bg = c.base },
          }
        end,
      }

      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin-mocha')
    end,
  },
}
