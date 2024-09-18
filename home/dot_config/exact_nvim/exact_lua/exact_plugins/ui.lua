return {
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = function(_, opts)
      table.insert(opts.presets, {
        lsp_doc_border = true,
      })
      opts.lsp = opts.lsp or {}
      opts.lsp.progress = opts.lsp.progress or {}
      opts.lsp.progress.enabled = false
      opts.messages = {
        enabled = false,
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
    'rcarriga/nvim-notify',
    opts = {
      -- background_colour = '#000000',
      level = vim.log.levels.ERROR, -- help vim.log.levels
      render = 'default',
      stages = 'fade_in_slide_out',
    },
  },
  {
    'luukvbaal/statuscol.nvim',
    config = function()
      require('statuscol').setup({
        setopt = true,
      })
    end,
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
      local colors = require('catppuccin.palettes').get_palette('mocha')
      require('incline').setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.surface0, guifg = colors.lavender },
            InclineNormalNC = { guibg = 'none', guifg = colors.overlay2 },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if vim.bo[props.buf].modified then
            filename = '[+] ' .. filename
          end

          local icon, color = require('nvim-web-devicons').get_icon_color(filename)
          return { { icon, guifg = color }, { ' ' }, { filename } }
        end,
      })
    end,
  },
  -- buffer line
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    opts = function(_, opts)
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
    init = function()
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
    config = function()
      local icons = require('utils.icons').get_icons()
      require('mini.icons').setup(icons)
    end,
  },

  -- Extend lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    config = function(_, opts)
      opts.options = vim.tbl_deep_extend('force', opts.options, {
        globalstatus = true,
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      })
      opts.sections = opts.sections or {}
      opts.sections.lualine_z = {}

      require('lualine').setup(opts)
    end,
  },
  {
    'DreamMaoMao/yazi.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },

    keys = {
      { '<leader>fy', '<cmd>Yazi<CR>', desc = 'Toggle Yazi' },
    },
  },
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      plugins = {
        gitsigns = true,
        wezterm = { enabled = true, font = '+4' },
      },
    },
    keys = { { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Zen Mode' } },
  },
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    opts = function(_, opts)
      local logo = [[

 ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
 ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
 ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
 ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
 ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

[miszo]
  ]]

      logo = string.rep('\n', 8) .. logo .. '\n\n'
      opts.config.header = vim.split(logo, '\n')
    end,
  },
}
