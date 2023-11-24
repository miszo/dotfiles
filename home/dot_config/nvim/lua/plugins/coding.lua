return {
  -- Create annotations with one keybind, and jump your cursor in the inserted annotation
  {
    'danymat/neogen',
    keys = {
      {
        '<leader>cc',
        function()
          require('neogen').generate({})
        end,
        desc = 'Neogen Comment',
      },
    },
    opts = { snippet_engine = 'luasnip' },
  },
  -- Refactoring
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
    config = function()
      require('refactoring').setup({})
    end,
    keys = {
      {
        '<leader>cR',
        ":lua require('refactoring').select_refactor()<CR>",
        mode = 'v',
        desc = 'Refactor',
      },
    },
  },
  -- Go forward/backward with square brackets
  {
    'echasnovski/mini.bracketed',
    event = 'BufReadPost',
    config = function()
      local bracketed = require('mini.bracketed')
      bracketed.setup({
        file = { suffix = '' },
        window = { suffix = '' },
        quickfix = { suffix = '' },
        yank = { suffix = '' },
        treesitter = { suffix = 'n' },
      })
    end,
  },
  -- Better increase/descrease
  {
    'monaqa/dial.nvim',
    keys = {
      {
        '<C-a>',
        function()
          return require('dial.map').inc_normal()
        end,
        expr = true,
        desc = 'Increment',
      },
      {
        '<C-x>',
        function()
          return require('dial.map').dec_normal()
        end,
        expr = true,
        desc = 'Decrement',
      },
    },
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { 'let', 'const' } }),
        },
      })
    end,
  },
  -- Display symbols outline
  {
    'simrat39/symbols-outline.nvim',
    keys = { { '<leader>cs', '<cmd>SymbolsOutline<cr>', desc = 'Symbols Outline' } },
    cmd = 'SymbolsOutline',
    opts = {
      position = 'right',
    },
  },
  -- Completion emoji
  {
    'nvim-cmp',
    dependencies = { 'hrsh7th/cmp-emoji' },
    opts = function(_, opts)
      table.insert(opts.sources, { name = 'emoji' })
    end,
  },
  -- Text case conversion
  {
    'johmsalas/text-case.nvim',
    config = true,
  },
  -- Word navigation
  {
    'chaoren/vim-wordmotion',
  },
  -- Tasks
  {
    'stevearc/overseer.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>rr',
        '<cmd>OverseerRun<cr>',
        desc = 'Run Tasks',
      },
      {
        '<leader>rt',
        '<cmd>OverseerToggle<cr>',
        desc = 'Toggle Tasks',
      },
      {
        '<leader>ra',
        '<cmd>OverseerTaskAction<cr>',
        desc = 'Task Action',
      },
      {
        '<leader>rs',
        function()
          require('util.tasks').stop_all_tasks()
        end,
        desc = 'Stop All Tasks',
      },
      {
        '<leader>rd',
        function()
          require('util.tasks').dispose_all_tasks()
        end,
        desc = 'Dispose All Tasks',
      },
      {
        '<leader>rq',
        function()
          local tasks = require('util.tasks')
          tasks.stop_all_tasks()
          tasks.dispose_all_tasks()
        end,
        desc = 'Stop and Dispose All Tasks',
      },
    },
    opts = {
      templates = {
        'cargo',
        'make',
        'npm',
        'shell',
        'deno',
        'cargo-make',
        'vscode',
      },
      task_list = {
        direction = 'bottom',
        min_height = { 15, 0.2 },
      },
    },
    config = true,
  },
}
