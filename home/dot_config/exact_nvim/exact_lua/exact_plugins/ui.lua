---@module "lazy"
---@type LazySpec[]
return {
  -- ui components
  { 'MunifTanjim/nui.nvim', lazy = true },

  -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    opts = {
      lsp = {
        progress = {
          enabled = false, -- disable LSP progress messages
        },
      },
      messages = {
        enabled = true, -- enable the messages UI
      },
      routes = {
        {
          filter = {
            event = 'notify',
            find = 'No information available',
          },
          opts = { skip = true },
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
    -- stylua: ignore
    keys = {
      { '<leader>sn', '', desc = '+noice'},
      { '<S-Enter>', function() require('noice').redirect(vim.fn.getcmdline()) end, mode = 'c', desc = 'Redirect Cmdline' },
      { '<leader>snl', function() require('noice').cmd('last') end, desc = 'Noice Last Message' },
      { '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice History' },
      { '<leader>sna', function() require('noice').cmd('all') end, desc = 'Noice All' },
      { '<leader>snd', function() require('noice').cmd('dismiss') end, desc = 'Dismiss All' },
      { '<leader>snt', function() require('noice').cmd('pick') end, desc = 'Noice Picker (Telescope/FzfLua)' },
      { '<c-b>', function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end, silent = true, expr = true, desc = 'Scroll Backward', mode = {'i', 'n', 's'}},
      { '<c-b>', function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end, silent = true, expr = true, desc = 'Scroll Backward', mode = {'i', 'n', 's'}},
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == 'lazy' then
        vim.cmd([[messages clear]])
      end
      require('noice').setup(opts)
    end,
  },
  {
    'j-hui/fidget.nvim',
    -- pin to a specific commit to avoid UI changes
    commit = '4ec7bed6c86b671ddde03ca1b227343cfa3e65fa',
    opts = {
      notification = {
        window = {
          winblend = 100,
          border = 'rounded',
        },
      },
    },
  },
  {
    'b0o/incline.nvim',
    dependencies = { 'catppuccin/nvim', 'echasnovski/mini.icons' },
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
  {
    'echasnovski/mini.icons',
    lazy = true,
    config = function()
      local icons = UserUtil.icons.get_icons()
      local mini_icons = require('mini.icons')
      mini_icons.setup(icons)
      mini_icons.mock_nvim_web_devicons()
    end,
  },
  {
    'sphamba/smear-cursor.nvim',
    event = 'VeryLazy',
    opts = {
      hide_target_hack = true,
      cursor_color = 'none',
    },
  },
}
