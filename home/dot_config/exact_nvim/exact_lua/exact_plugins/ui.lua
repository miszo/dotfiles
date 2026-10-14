---@module 'lazy'
---@type LazySpec[]
return {
  -- ui components
  { 'MunifTanjim/nui.nvim', lazy = true },
  {
    'j-hui/fidget.nvim',
    version = '*',
    opts = {
      progress = {
        display = {
          progress_ttl = math.huge,
          done_ttl = 3,
        },
        lsp = {
          log_handler = true,
        },
      },
      notification = {
        override_vim_notify = false,
        window = {
          normal_hl = 'NormalFloat',
          winblend = 0,
          border = 'rounded',
          border_hl = 'FloatBorder',
        },
      },
    },
  },
  {
    'nvim-mini/mini.icons',
    lazy = true,
    config = function()
      local icons = UserUtil.icons.get_icons()
      local mini_icons = require('mini.icons')
      mini_icons.setup(icons)
      mini_icons.mock_nvim_web_devicons()
    end,
  },
  {
    'm4xshen/smartcolumn.nvim',
    opts = {
      colorcolumn = '120',
      disabled_filetypes = UserConfig.filetypes.excluded_from_smartcolumn,
    },
  },
}
