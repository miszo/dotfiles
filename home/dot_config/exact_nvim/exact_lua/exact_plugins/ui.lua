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
    config = function()
      require('statuscol').setup({
        setopt = true,
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
      local icons = require('utils.icons')

      local js_table = { glyph = icons.files.test, hl = 'MiniIconsYellow' }
      local jsx_table = { glyph = icons.files.test, hl = 'MiniIconsAzure' }
      local ts_table = { glyph = icons.files.test, hl = 'MiniIconsAzure' }
      local tsx_table = { glyph = icons.files.test, hl = 'MiniIconsBlue' }
      local eslint_table = { glyph = icons.files.eslint, hl = 'MiniIconsBlue' }
      local prettier_table = { glyph = icons.files.prettier, hl = 'MiniIconsOrange' }
      local tw_table = { glyph = icons.files.tailwind, hl = 'MiniIconsAzure' }
      local npm_table = { glyph = icons.files.npm, hl = 'MiniIconsRed' }
      local node_table = { glyph = icons.files.node, hl = 'MiniIconsGreen' }
      local yarn_table = { glyph = icons.files.yarn, hl = 'MiniIconsCyan' }

      require('mini.icons').setup({
        file = {
          ['.nvmrc'] = node_table,
          ['.node-version'] = node_table,
          ['.tool-versions'] = { glyph = icons.files.tool, hl = 'MiniIconsGrey' },
          ['.eslintrc'] = eslint_table,
          ['.eslintrc.json'] = eslint_table,
          ['.eslintrc.js'] = eslint_table,
          ['.eslintrc.cjs'] = eslint_table,
          ['.eslintrc.mjs'] = eslint_table,
          ['.eslintignore'] = { glyph = icons.files.eslint, hl = 'MiniIconsPurple' },
          ['eslint.config.js'] = eslint_table,
          ['eslint.config.cjs'] = eslint_table,
          ['eslint.config.mjs'] = eslint_table,
          ['.prettierignore'] = { glyph = icons.files.prettier, hl = 'MiniIconsPurple' },
          ['.prettierrc'] = prettier_table,
          ['.prettierrc.json'] = prettier_table,
          ['.prettierrc.js'] = prettier_table,
          ['.prettierrc.cjs'] = prettier_table,
          ['.prettierrc.mjs'] = prettier_table,
          ['prettier.config.js'] = prettier_table,
          ['prettier.config.cjs'] = prettier_table,
          ['prettier.config.mjs'] = prettier_table,
          ['tailwind.config.js'] = tw_table,
          ['tailwind.config.cjs'] = tw_table,
          ['tailwind.config.mjs'] = tw_table,
          ['tsconfig.json'] = { glyph = icons.files.tsconfig, hl = 'MiniIconsAzure' },
          ['.npmrc'] = npm_table,
          ['.npmignore'] = npm_table,
          ['package.json'] = npm_table,
          ['package-lock.json'] = npm_table,
          ['yarn.lock'] = yarn_table,
          ['.yarnrc'] = yarn_table,
          ['.yarnrc.yml'] = yarn_table,
          ['.yarnrc.yaml'] = yarn_table,
        },
        extension = {
          ['test.js'] = js_table,
          ['test.jsx'] = jsx_table,
          ['test.ts'] = ts_table,
          ['test.tsx'] = tsx_table,
          ['spec.js'] = js_table,
          ['spec.jsx'] = jsx_table,
          ['spec.ts'] = ts_table,
          ['spec.tsx'] = tsx_table,
          ['cy.js'] = js_table,
          ['cy.jsx'] = jsx_table,
          ['cy.ts'] = ts_table,
          ['cy.tsx'] = tsx_table,
        },
      })
    end,
  },

  -- Extend lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    config = function(_, opts)
      opts.options = vim.tbl_deep_extend('keep', opts.options, {
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
        kitty = { enabled = true, font = '+2' },
      },
    },
    keys = { { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Zen Mode' } },
  },
  { 'folke/twilight.nvim' },
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
