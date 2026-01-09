---@module 'lazy'
---@type LazySpec[]
return {
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    opts = function()
      local colors = require('catppuccin.palettes').get_palette()
      ---@type CatppuccinOptions
      return {
        flavour = 'mocha',
        transparent_background = false,
        term_colors = true,
        styles = {
          comments = { 'italic' },
          conditionals = {},
          functions = { 'italic' },
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          operators = {},
          types = {},
        },
        lsp_styles = {
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
            ok = { 'italic' },
          },
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
            ok = { 'undercurl' },
          },
          inlay_hints = {
            background = true,
          },
        },
        integrations = {
          blink_cmp = true,
          fidget = true,
          dadbod_ui = true,
          flash = true,
          grug_far = true,
          gitsigns = true,
          indent_blankline = { enabled = true },
          lsp_trouble = true,
          mason = true,
          markdown = true,
          mini = true,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { 'undercurl' },
              hints = { 'undercurl' },
              warnings = { 'undercurl' },
              information = { 'undercurl' },
            },
            inlay_hints = { background = true },
          },
          navic = {
            enabled = true,
            custom_bg = colors.mantle,
          },
          neotest = true,
          noice = true,
          notify = true,
          render_markdown = true,
          semantic_tokens = true,
          snacks = true,
          treesitter = true,
          treesitter_context = true,
          which_key = true,
        },
        highlight_overrides = {
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
              SidekickDiffAdd = { link = 'DiffAdd' },
              SidekickDiffDelete = { link = 'DiffDelete' },
            }
          end,
        },
      }
    end,
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin-mocha')
    end,
  },
}
