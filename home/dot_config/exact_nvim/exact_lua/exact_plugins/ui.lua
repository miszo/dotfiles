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
      opts.lsp.progress = vim.tbl_extend('keep', opts.lsp, {
        progress = {
          enabled = true,
        },
      })
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
    config = true,
  },
  -- buffer line
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    keys = {
      { '<Tab>', '<Cmd>BufferLineCycleNext<CR>', desc = 'Next tab' },
      { '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', desc = 'Prev tab' },
    },
    opts = function(_, opts)
      opts.options = vim.tbl_extend('force', opts.options, {
        show_buffer_close_icons = false,
        show_close_icon = false,
      })
    end,
  },
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').set_icon({
        gql = {
          icon = '',
          color = '#e535ab',
          cterm_color = '199',
          name = 'GraphQL',
        },
      })
    end,
  },
  {
    'b0o/incline.nvim',
    dependencies = { 'bluz71/vim-nightfly-guicolors', name = 'nightfly' },
    event = 'BufReadPre',
    priority = 1200,
    config = function()
      local colors = require('nightfly').palette
      require('incline').setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.black_blue, guifg = colors.purple },
            InclineNormalNC = { guibg = colors.black_blue, guifg = colors.plant_green },
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
  -- Extend lualine for tasks
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'stevearc/overseer.nvim' },
    event = 'VeryLazy',
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, { 'overseer' })
    end,
  },
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      plugins = {
        gitsigns = true,
        kitty = { enabled = true, font = '+2' },
      },
    },
    keys = { { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Zen Mode' } },
  },
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    opts = function(_, opts)
      local logo = [[
███╗   ███╗██╗███████╗███████╗ ██████╗    ██████╗ ███████╗██╗   ██╗
████╗ ████║██║██╔════╝╚══███╔╝██╔═══██╗   ██╔══██╗██╔════╝██║   ██║
██╔████╔██║██║███████╗  ███╔╝ ██║   ██║   ██║  ██║█████╗  ██║   ██║
██║╚██╔╝██║██║╚════██║ ███╔╝  ██║   ██║   ██║  ██║██╔══╝  ╚██╗ ██╔╝
██║ ╚═╝ ██║██║███████║███████╗╚██████╔╝██╗██████╔╝███████╗ ╚████╔╝
╚═╝     ╚═╝╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝╚═════╝ ╚══════╝  ╚═══╝
      ]]

      logo = string.rep('\n', 8) .. logo .. '\n\n'
      opts.config.header = vim.split(logo, '\n')
    end,
  },
}
