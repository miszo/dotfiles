---@module 'lazy'
---@type LazySpec[]
return {
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    opts = function(_, opts)
      table.insert(opts.presets, {
        lsp_doc_border = true,
      })
      opts.lsp = opts.lsp or {}
      opts.lsp.progress = opts.lsp.progress or {}
      opts.lsp.progress.enabled = false
      opts.messages = {
        enabled = true,
      }
      opts.routes = {
        filter = { event = 'notify', find = 'No information available' },
        opts = { skip = true },
      }
    end,
    keys = {
      { '<leader>nd', '<cmd>NoiceDismiss<CR>', desc = 'Dismiss Noice Message' },
    },
  },
  {
    'j-hui/fidget.nvim',
    opts = {
      notification = {
        window = {
          winblend = 0,
          border = 'rounded',
        },
      },
    },
  },
  -- filename
  {
    'b0o/incline.nvim',
    dependencies = { 'catppuccin/nvim' },
    event = 'BufReadPre',
    priority = 1200,
    config = function()
      local colors = require('catppuccin.palettes').get_palette()
      require('incline').setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.crust, guifg = colors.lavender },
            InclineNormalNC = { guibg = colors.none, guifg = colors.overlay2 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 0 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          local modified = vim.bo[props.buf].modified

          local icon, color = require('nvim-web-devicons').get_icon_color(filename)
          return {
            { icon, guifg = color },
            { ' ' },
            { filename },
            modified and { ' ●', guifg = colors.peach } or {},
          }
        end,
      })
    end,
  },
  -- buffer line
  {
    'akinsho/bufferline.nvim',
    dependencies = { 'catppuccin/nvim' },
    event = 'VeryLazy',
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options = vim.tbl_extend('force', opts.options, {
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = 'slant',
        always_show_bufferline = true,
      })
    end,
  },

  {
    'echasnovski/mini.icons',
    lazy = true,
    config = function()
      local icons = require('utils.icons').get_icons()
      local mini_icons = require('mini.icons')
      mini_icons.setup(icons)
      mini_icons.mock_nvim_web_devicons()
    end,
  },

  -- Extend lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'echasnovski/mini.icons' },
    event = 'VeryLazy',
    config = function(_, opts)
      local statusline = require('utils.statusline')
      opts.options = vim.tbl_deep_extend('force', opts.options, {
        globalstatus = true,
        icons_enabled = true,
        theme = 'catppuccin',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      })
      opts.sections = opts.sections or {}
      table.insert(opts.sections.lualine_x, {
        statusline.attached_clients,
        padding = statusline.padding,
        cond = statusline.show_attached_clients,
      })
      opts.sections.lualine_z = {}

      require('lualine').setup(opts)
    end,
  },
}
