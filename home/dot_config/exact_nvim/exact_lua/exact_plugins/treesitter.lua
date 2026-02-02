---@module 'lazy'
---@type LazySpec[]
return {
  {
    'folke/which-key.nvim',
    opts = {
      spec = {
        { '<BS>', desc = 'Decrement Selection', mode = 'x' },
        { '<c-space>', desc = 'Increment Selection', mode = { 'x', 'n' } },
      },
    },
  },
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    dependencies = {
      'windwp/nvim-ts-autotag',
      'RRethy/nvim-treesitter-endwise',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
      { 'LiadOz/nvim-dap-repl-highlights' },
    },
    build = function()
      local TS = require('nvim-treesitter')
      if not TS.get_installed then
        UserUtil.lazyCoreUtil.error(
          'Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.'
        )
        return
      end
      vim.cmd.TSUpdate()
    end,
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    event = { 'LazyFile', 'VeryLazy' },
    cmd = { 'TSUpdate', 'TSInstall', 'TSLog', 'TSUninstall' },
    opts_extend = { 'ensure_installed' },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      ensure_installed = {
        'angular',
        'bash',
        'blade',
        'c',
        'cpp',
        'css',
        'dap_repl',
        'diff',
        'dockerfile',
        'gitignore',
        'go',
        'graphql',
        'html',
        'http',
        'javascript',
        'jsdoc',
        'json',
        'json5',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'mermaid',
        'php',
        'prisma',
        'printf',
        'python',
        'query',
        'regex',
        'ruby',
        'rust',
        'scss',
        'ssh_config',
        'sql',
        'svelte',
        'swift',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'vue',
        'xml',
        'yaml',
        'zig',
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      local TS = require('nvim-treesitter')
      -- have to setup dap repl highlights before treesitter
      require('nvim-dap-repl-highlights').setup()

      -- checks for treesitter main branch
      if not TS.get_installed then
        return UserUtil.lazyCoreUtil.error('Please use `:Lazy` and update `nvim-treesitter`')
      elseif vim.fn.executable('tree-sitter') == 0 then
        return UserUtil.lazyCoreUtil.error({
          '**treesitter-main** requires the `tree-sitter` CLI executable to be installed.',
          'Run `:checkhealth nvim-treesitter` for more information.',
        })
      elseif type(opts.ensure_installed) ~= 'table' then
        return UserUtil.lazyCoreUtil.error('`nvim-treesitter` opts.ensure_installed must be a table')
      end

      -- setup treesitter
      TS.setup(opts)

      UserUtil.treesitter.get_installed(true) -- initialize installed langs

      -- install missing parsers
      local install = vim.tbl_filter(function(lang)
        return not UserUtil.treesitter.have(lang)
      end, opts.ensure_installed or {})
      if #install > 0 then
        TS.install(install, { summary = true }):await(function()
          UserUtil.treesitter.get_installed(true) -- refresh the installed langs
        end)
      end

      -- treesitter highlighting
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('miszo/nvim_treesitter', { clear = true }),
        callback = function(ev)
          local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
          if not UserUtil.treesitter.have(ft) then
            return
          end

          ---@param feat string
          ---@param query string
          local function enabled(feat, query)
            local f = opts[feat] or {} ---@type lazyvim.TSFeat
            return f.enable ~= false
              and not (type(f.disable) == 'table' and vim.tbl_contains(f.disable, lang))
              and UserUtil.treesitter.have(ft, query)
          end

          -- highlighting
          if enabled('highlight', 'highlights') then
            pcall(vim.treesitter.start, ev.buf)
          end

          -- indents
          if enabled('indent', 'indents') then
            vim.api.nvim_set_option_value('indentexpr', 'v:lua.UserUtil.treesitter.indentexpr()', { scope = 'local' })
          end

          -- folds
          if enabled('folds', 'folds') then
            vim.api.nvim_set_option_value('foldmethod', 'expr', { scope = 'local' })
            vim.api.nvim_set_option_value('foldexpr', 'v:lua.UserUtil.treesitter.foldexpr()', { scope = 'local' })
          end
        end,
      })

      -- add angular suppport for template files
      vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
        pattern = { '*.component.html', '*.container.html' },
        callback = function()
          vim.treesitter.start(nil, 'angular')
        end,
      })

      -- add blade custom parser
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TSUpdate',
        callback = function()
          local parsers = require('nvim-treesitter.parsers')
          parsers.blade = {
            install_info = {
              url = 'https://github.com/EmranMR/tree-sitter-blade',
            },
          }
          parsers.just = {
            install_info = {
              url = 'https://github.com/IndianBoy42/tree-sitter-just', -- local path or git repo
              files = { 'src/parser.c', 'src/scanner.c' },
              branch = 'main',
            },
            maintainers = { '@IndianBoy42' },
          }

          -- MDX support
          vim.filetype.add({
            extension = {
              mdx = 'mdx',
            },
            -- blade files pattern
            pattern = {
              ['.*%.blade%.php'] = 'blade',
            },
          })
          -- register mdx as markdown for treesitter
          vim.treesitter.language.register('markdown', 'mdx')
        end,
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    opts = {},
    keys = function()
      local moves = {
        goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
        goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
        goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
        goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
      }
      local ret = {} ---@type LazyKeysSpec[]
      for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
          local desc = query:gsub('@', ''):gsub('%..*', '')
          desc = desc:sub(1, 1):upper() .. desc:sub(2)
          desc = (key:sub(1, 1) == '[' and 'Prev ' or 'Next ') .. desc
          desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and ' End' or ' Start')
          ret[#ret + 1] = {
            key,
            function()
              -- don't use treesitter if in diff mode and the key is one of the c/C keys
              if vim.wo.diff and key:find('[cC]') then
                return vim.cmd('normal! ' .. key)
              end
              require('nvim-treesitter-textobjects.move')[method](query, 'textobjects')
            end,
            desc = desc,
            mode = { 'n', 'x', 'o' },
            silent = true,
          }
        end
      end
      return ret
    end,
    config = function(_, opts)
      local TS = require('nvim-treesitter-textobjects')
      if not TS.setup then
        UserUtil.lazyCoreUtil.error('Please use `:Lazy` and update `nvim-treesitter`')
        return
      end
      TS.setup(opts)
    end,
  },

  -- Automatically add closing tags for HTML and JSX
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    opts = {},
  },
  {
    'Wansmer/treesj',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
      },
    },
    config = function()
      local tsj = require('treesj')
      tsj.setup({
        use_default_keymaps = false,
      })
      vim.keymap.set('n', '<leader>m', tsj.toggle, { desc = 'Toggle split/join code block' })
    end,
  },
  -- Chezmoi syntax highlighting
  {
    'alker0/chezmoi.vim',
  },
}
