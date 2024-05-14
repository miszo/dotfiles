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
          augend.constant.new({ elements = { 'start', 'end' } }),
          augend.constant.new({ elements = { 'as', 'satisfies' } }),
          augend.constant.new({ elements = { 'before', 'after' } }),
          augend.constant.new({ elements = { 'left', 'right' } }),
          augend.constant.new({ elements = { '&&', '||' } }),
          augend.case.new({ types = { 'PascalCase', 'camelCase', 'snake_case', 'kebab-case', 'SCREAMING_SNAKE_CASE' } }),
        },
      })
    end,
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
        '<leader>r',
        desc = 'Overseer',
      },
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
      {
        '<leader>rR',
        function()
          require('util.tasks').restart_all_tasks()
        end,
        desc = 'Restart All Tasks',
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
  -- Better TS Errors
  {
    'OlegGulevskyy/better-ts-errors.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
      keymaps = {
        toggle = '<leader>cx', -- default '<leader>dd'
        go_to_definition = '<leader>dx', -- default '<leader>dx'
      },
    },
  },
  -- Todo Comments
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = 'LazyFile',
    config = true,
    keys = {
      {
        ']k',
        function()
          require('todo-comments').jump_next()
        end,
        desc = 'Next todo comment',
      },
      {
        '[k',
        function()
          require('todo-comments').jump_prev()
        end,
        desc = 'Previous todo comment',
      },
    },
  },
  -- NPM Package info
  {
    'vuki656/package-info.nvim',
    dependencies = { 'folke/which-key.nvim', 'MunifTanjim/nui.nvim', 'catppuccin/nvim' },
    ft = { 'json' },
    opts = {
      autostart = true,
      hide_up_to_date = true,
      hide_unstable_versions = false,
      package_manager = 'pnpm',
    },
    keys = function()
      require('which-key').register({ n = { name = '+PackageInfo' } }, { prefix = '<leader>' })
      local function map(key, cmd, desc)
        vim.keymap.set({ 'n' }, '<LEADER>n' .. key, cmd, { desc = desc, silent = true, noremap = true })
      end
      local pi = require('package-info')
      map('s', pi.show, 'Show package info')
      map('h', pi.hide, 'Hide package info')
      map('n', pi.toggle, 'Toggle package info')
      map('u', pi.update, 'Update package')
      map('d', pi.delete, 'Delete package')
      map('i', pi.install, 'Install package')
      map('v', pi.change_version, 'Change package version')
    end,
  },
  -- Local plugins
  {
    dir = '../local-plugins/copy-filepath',
    config = function()
      require('../local-plugins/copy-filepath').setup()
    end,
  },
}
