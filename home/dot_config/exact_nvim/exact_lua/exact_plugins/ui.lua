---@param msg NoiceMessage
local function get_noice_title(msg)
  return msg.title or (msg.opts and msg.opts.title) or ''
end

---@module 'lazy'
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
    ---@type NoiceConfig
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
        progress = {
          enabled = true, -- enable LSP progress messages in mini view
          format = 'lsp_progress',
          format_done = 'lsp_progress_done',
          throttle = 1000 / 30,
          view = 'mini',
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
        -- Route notifications to mini view
        {
          filter = {
            event = 'notify',
            ---@param msg NoiceMessage
            cond = function(msg)
              return vim.tbl_contains(
                { 'pkg-version.nvim', 'mason.nvim', 'nvim-treesitter', 'lazy.nvim' },
                get_noice_title(msg)
              )
            end,
          },
          view = 'mini',
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = false,
        lsp_doc_border = true,
      },
      views = {
        mini = {
          backend = 'mini',
          relative = 'editor',
          align = 'message-right',
          timeout = 3000,
          reverse = true,
          position = {
            row = -2,
            col = '100%',
          },
          size = {
            width = 'auto',
            height = 'auto',
            max_height = 40,
            max_width = 120,
          },
          border = {
            style = vim.g.border_style or 'rounded',
          },
          win_options = {
            winblend = 0,
            winhighlight = {
              Normal = 'NoiceMini',
              FloatBorder = 'NoiceMini',
            },
          },
        },
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
      { '<leader>snt', function() require('noice').cmd('pick') end, desc = 'Noice Picker' },
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
    'sphamba/smear-cursor.nvim',
    event = 'VeryLazy',
    opts = {
      hide_target_hack = true,
      cursor_color = 'none',
    },
  },
}
