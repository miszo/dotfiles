---@type LazySpec[]
return {
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    config = function(_, opts)
      local colors = require('catppuccin.palettes').get_palette()
      opts.flavour = 'mocha'
      opts.transparent_background = true

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
        overseer = true,
        snacks = true,
        telescope = {
          enabled = true,
          style = 'nvchad',
        },
        which_key = true,
      })

      opts.highlight_overrides = opts.highlight_overrides or {}
      opts.highlight_overrides = {
        all = function(c)
          return {
            TelescopeSelection = { fg = c.text, bg = c.surface0 },
            PackageInfoOutdatedVersion = { fg = c.peach },
            PackageInfoUpToDateVersion = { fg = c.green },
            PackageInfoInErrorVersion = { fg = c.red },
            SnacksIndent = { link = 'Whitespace' },
            SnacksIndentScope = { fg = c.text },
          }
        end,
      }

      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin-mocha')
    end,
  },
}
