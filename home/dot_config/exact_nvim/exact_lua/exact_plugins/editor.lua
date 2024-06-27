return {
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
  {
    {
      'MagicDuck/grug-far.nvim',
      event = 'VeryLazy',
      cmd = 'GrugFar',
      config = function()
        require('grug-far').setup({
          vim.keymap.set('n', '<leader>sr', '<cmd>GrugFar<cr>', { desc = 'Find And Replace (GrugFar)', silent = true }),
        })
      end,
    },
  },
  -- Open openapi preview in swagger-ui
  {
    'vinnymeller/swagger-preview.nvim',
    build = 'npm install -g swagger-ui-watcher',
    keys = {
      {
        '<leader>os',
        function()
          require('swagger-preview').start_server()
        end,
        { desc = 'Open preview OpenAPI in Swagger UI' },
      },
      {
        '<leader>ox',
        function()
          require('swagger-preview').stop_server()
        end,
        { desc = 'Stop preview OpenAPI in Swagger UI' },
      },
      {
        '<leader>ot',
        function()
          require('swagger-preview').toggle_server()
        end,
        { desc = 'Toggle preview OpenAPI in Swagger UI' },
      },
    },
    config = function()
      require('swagger-preview').setup({
        port = 1111,
        host = 'localhost',
      })
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
