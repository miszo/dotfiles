---@module 'lazy'
---@type LazySpec[]
return {

  -- search/replace in multiple files
  {
    'MagicDuck/grug-far.nvim',
    opts = { headerMaxWidth = 80 },
    cmd = { 'GrugFar', 'GrugFarWithin' },
    keys = {
      {
        '<leader>sr',
        function()
          local grug = require('grug-far')
          local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
          local files_filter = ext and ext ~= '' and '*.' .. ext or nil
          local frontend_exts = { 'js', 'jsx', 'ts', 'tsx' }
          if vim.tbl_contains(frontend_exts, ext) then
            files_filter = '*.{' .. table.concat(frontend_exts, ',') .. '}'
          end

          grug.open({
            transient = true,
            prefills = {
              filesFilter = files_filter,
            },
          })
        end,
        mode = { 'n', 'v' },
        desc = 'Search and Replace',
      },
      {
        '<leader>sR',
        ':GrugFarWithin<cr>',
        mode = { 'v', 'x' },
        desc = 'Search and Replace whithin selection',
      },
    },
  },

  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    vscode = true,
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'o', 'x' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
      {
        '<c-space>',
        mode = { 'n', 'o', 'x' },
        function()
          require('flash').treesitter({
            actions = {
              ['<c-space>'] = 'next',
              ['<BS>'] = 'prev',
            },
          })
        end,
        desc = 'Treesitter Incremental Selection',
      },
    },
  },

  -- git signs highlights text that has changed since the list
  -- git commit, and also lets you interactively stage & unstage
  -- hunks in a commit.
  {
    'lewis6991/gitsigns.nvim',
    event = 'LazyFile',
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gs.nav_hunk('next')
          end
        end, 'Next Hunk')
        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gs.nav_hunk('prev')
          end
        end, 'Prev Hunk')
        map('n', ']H', function()
          gs.nav_hunk('last')
        end, 'Last Hunk')
        map('n', '[H', function()
          gs.nav_hunk('first')
        end, 'First Hunk')
        map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
        map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
        map('n', '<leader>ghS', gs.stage_buffer, 'Stage Buffer')
        map('n', '<leader>ghu', gs.undo_stage_hunk, 'Undo Stage Hunk')
        map('n', '<leader>ghR', gs.reset_buffer, 'Reset Buffer')
        map('n', '<leader>ghp', gs.preview_hunk_inline, 'Preview Hunk Inline')
        map('n', '<leader>ghb', function()
          gs.blame_line({ full = true })
        end, 'Blame Line')
        map('n', '<leader>ghB', function()
          gs.blame()
        end, 'Blame Buffer')
        map('n', '<leader>ghd', gs.diffthis, 'Diff This')
        map('n', '<leader>ghD', function()
          gs.diffthis('~')
        end, 'Diff This ~')
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
      end,
    },
  },
  {
    'gitsigns.nvim',
    opts = function()
      Snacks.toggle({
        name = 'Git Signs',
        get = function()
          return require('gitsigns.config').config.signcolumn
        end,
        set = function(state)
          require('gitsigns').toggle_signs(state)
        end,
      }):map('<leader>uG')
    end,
  },

  -- better diagnostics list and others
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble' },
    opts = {
      modes = {
        lsp = {
          win = { position = 'right' },
        },
      },
    },
    specs = {
      'folke/snacks.nvim',
      opts = function(_, opts)
        return vim.tbl_deep_extend('force', opts or {}, {
          picker = {
            actions = require('trouble.sources.snacks').actions,
            win = {
              input = {
                keys = {
                  ['<c-t>'] = {
                    'trouble_open',
                    mode = { 'n', 'i' },
                  },
                },
              },
            },
          },
        })
      end,
    },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
      {
        '[q',
        function()
          if require('trouble').is_open() then
            require('trouble').prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Previous Trouble/Quickfix Item',
      },
      {
        ']q',
        function()
          if require('trouble').is_open() then
            require('trouble').next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Next Trouble/Quickfix Item',
      },
    },
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble' },
    event = 'LazyFile',
    opts = {},
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        desc = 'Next Todo Comment',
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        desc = 'Previous Todo Comment',
      },
      { '<leader>xt', '<cmd>Trouble todo toggle<cr>', desc = 'Todo (Trouble)' },
      {
        '<leader>xT',
        '<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>',
        desc = 'Todo/Fix/Fixme (Trouble)',
      },
      {
        '<leader>st',
        function()
          Snacks.picker.todo_comments()
        end,
        desc = 'Todo',
      },
      {
        '<leader>sT',
        function()
          Snacks.picker.todo_comments({ keywords = { 'TODO', 'FIX', 'FIXME' } })
        end,
        desc = 'Todo/Fix/Fixme',
      },
    },
  },
  -- Word navigation
  {
    'chaoren/vim-wordmotion',
  },
  -- Open openapi preview in swagger-ui
  {
    'vinnymeller/swagger-preview.nvim',
    build = 'npm install',
    cmd = { 'SwaggerPreview', 'SwaggerPreviewStop', 'SwaggerPreviewToggle' },
    keys = {
      { '<leader>O', '', desc = '+OpenAPI Swagger' },
      {
        '<leader>Os',
        function()
          require('swagger-preview').start_server()
        end,
        desc = 'Open preview OpenAPI in Swagger UI',
      },
      {
        '<leader>Ox',
        function()
          require('swagger-preview').stop_server()
        end,
        desc = 'Stop preview OpenAPI in Swagger UI',
      },
      {
        '<leader>Ot',
        function()
          require('swagger-preview').toggle_server()
        end,
        desc = 'Toggle preview OpenAPI in Swagger UI',
      },
    },
    config = function()
      require('swagger-preview').setup({
        port = 9876,
        host = 'localhost',
      })
    end,
  },
  -- Find other files
  {
    'rgroli/other.nvim',
    keys = {
      { 'go', '<cmd>Other<CR>', desc = 'Alternate file' },
      { 'gV', '<cmd>OtherVSplit<CR>', desc = 'Alternate file (vsplit)' },
    },
    cmd = { 'Other', 'OtherSplit', 'OtherVSplit' },
    config = function()
      require('other-nvim').setup({
        mappings = {
          'angular',
          'rails',

          -- the "going back to source from tests" from the Rails builtin but with a _spec suffix
          {
            pattern = '(.+)/spec/(.*)/(.*)/(.*)_spec.rb',
            target = {
              { target = '%1/db/%3/%4.rb' },
              { target = '%1/app/%3/%4.rb' },
              { target = '%1/%3/%4.rb' },
            },
          },
          {
            pattern = '(.+)/spec/(.*)/(.*)_spec.rb',
            target = {
              { target = '%1/db/%2/%3.rb' },
              { target = '%1/app/%2/%3.rb' },
              { target = '%1/lib/%2/%3.rb' },
            },
          },
          {
            pattern = '(.+)/spec/(.*)/(.*)_(.*)_spec.rb',
            target = {
              { target = '%1/app/%4s/%3_%4.rb' },
            },
          },
          {
            pattern = '/lib/(.*)/(.*).rb',
            target = '/spec/lib/%1/%2_spec.rb',
            context = 'test',
          },
          -- Jest tests
          {
            pattern = '(.*)/(.*).ts$',
            target = '%1/%2.test.ts',
            context = 'test',
          },
          {
            pattern = '(.*)/(.*).tsx$',
            target = '%1/%2.test.tsx',
            context = 'test',
          },
          -- Back from tests to files
          {
            pattern = '(.*)/(.*).test.ts$',
            target = '%1/%2.ts',
            context = 'source',
          },
          {
            pattern = '(.*)/(.*).test.tsx$',
            target = '%1/%2.tsx',
            context = 'source',
          },
        },
        rememberBuffers = false,
        showMissingFiles = false,
      })
    end,
  },
  -- Go forward/backward with square brackets
  {
    'nvim-mini/mini.bracketed',
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
  {
    'nvim-mini/mini.move',
    event = 'VeryLazy',
    opts = {
      mappings = {
        left = '<M-h>',
        right = '<M-l>',
        down = '<M-j>',
        up = '<M-k>',
        line_left = '<M-h>',
        line_right = '<M-l>',
        line_down = '<M-j>',
        line_up = '<M-k>',
      },
      options = {
        reindent_linewise = true,
      },
    },
  },
  {
    'SmiteshP/nvim-navic',
    lazy = true,
    init = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local buf = event.buf
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol) then
            require('nvim-navic').attach(client, buf)
          end
        end,
      })
    end,
    opts = function()
      return {
        separator = ' ',
        highlight = true,
        depth_limit = 5,
        icons = UserConfig.icons.kinds,
        lazy_update_context = true,
      }
    end,
  },
}
