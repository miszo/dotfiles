---@module 'lazy'
---@type LazySpec[]
local function patch_tree_sitter_manager_installer()
  local installer = require('tree-sitter-manager.installer')
  if installer._miszo_patched then
    return
  end

  local config = require('tree-sitter-manager.config')
  local util = require('tree-sitter-manager.util')

  local copy_dir = util.copy_dir
  util.copy_dir = function(src, dst)
    vim.fs.rm(dst, { recursive = true, force = true })
    return copy_dir(src, dst)
  end

  local install = installer.install

  ---@param lang string
  ---@param ret string[]
  ---@param seen table<string,boolean>
  local function add_with_deps(lang, ret, seen)
    if seen[lang] then
      return
    end
    seen[lang] = true

    if config.effective_repos[lang] then
      for _, dep in ipairs(util.get_requires(lang)) do
        add_with_deps(dep, ret, seen)
      end
    end

    ret[#ret + 1] = lang
  end

  function installer.install(languages, callback, no_deps, force)
    callback = callback or function() end
    if type(languages) == 'string' then
      languages = { languages }
    end

    local ret, seen = {}, {}
    for _, lang in ipairs(languages or {}) do
      if no_deps then
        if not seen[lang] then
          seen[lang] = true
          ret[#ret + 1] = lang
        end
      else
        add_with_deps(lang, ret, seen)
      end
    end

    local index = 0
    local function next_install()
      index = index + 1
      local lang = ret[index]
      if not lang then
        return
      end

      if installer.status[lang] and (installer.status[lang].ok or installer.status[lang].installing) then
        callback(installer.status[lang])
        return next_install()
      elseif not config.effective_repos[lang] then
        installer.status[lang] = { ok = false, error = 'Parser not found in repos' }
        vim.notify('⚠ Parser not found in repos: ' .. lang, vim.log.levels.WARN)
        callback(installer.status[lang])
        return next_install()
      elseif not force and util.is_installed(lang) then
        installer.status[lang] = { ok = true }
        callback(installer.status[lang])
        return next_install()
      end

      install(lang, function(out)
        callback(out)
        next_install()
      end, true, force)
    end

    next_install()
  end

  installer._miszo_patched = true
end

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
  {
    'romus204/tree-sitter-manager.nvim',
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    event = { 'LazyFile', 'VeryLazy' },
    cmd = { 'TSManager', 'TSInstall', 'TSUninstall' },
    opts = {
      ensure_installed = {
        'angular',
        'astro',
        'awk',
        'bash',
        'bicep',
        'blade',
        'c',
        'c_sharp',
        'caddy',
        'comment',
        'cmake',
        'cpp',
        'css',
        'dap_repl',
        'dart',
        'diff',
        'dockerfile',
        'dtd',
        'ecma',
        'editorconfig',
        'elixir',
        'erlang',
        'fish',
        'fsh',
        'ghostty',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'glimmer',
        'glimmer_javascript',
        'glimmer_typescript',
        'go',
        'gomod',
        'haskell',
        'haskell_persistent',
        'hcl',
        'graphql',
        'html',
        'html_tags',
        'htmldjango',
        'http',
        'java',
        'javadoc',
        'javascript',
        'jq',
        'jsdoc',
        'json',
        'json5',
        'jsx',
        'just',
        'kitty',
        'kotlin',
        'latex',
        'lua',
        'luadoc',
        'luap',
        'luau',
        'make',
        'markdown',
        'markdown_inline',
        'matlab',
        'mermaid',
        'nginx',
        'nix',
        'nu',
        'ocaml',
        'ocaml_interface',
        'odin',
        'passwd',
        'php',
        'php_only',
        'phpdoc',
        'powershell',
        'prisma',
        'printf',
        'python',
        'query',
        'regex',
        'robots_txt',
        'ruby',
        'rust',
        'scala',
        'scss',
        'ssh_config',
        'styled',
        'sql',
        'svelte',
        'swift',
        'terraform',
        'todotxt',
        'toml',
        'tsx',
        'twig',
        'typescript',
        'vim',
        'vimdoc',
        'vue',
        'xml',
        'yaml',
        'zig',
        'zsh',
      },
      auto_install = false,
      highlight = false,
      languages = {
        dap_repl = {
          install_info = {
            url = 'https://github.com/LiadOz/nvim-dap-repl-highlights',
            branch = 'master',
            queries = 'queries/dap_repl',
            use_repo_queries = true,
          },
        },
        blade = {
          install_info = {
            url = 'https://github.com/EmranMR/tree-sitter-blade',
            use_repo_queries = true,
          },
        },
        just = {
          install_info = {
            url = 'https://github.com/IndianBoy42/tree-sitter-just',
            files = { 'src/parser.c', 'src/scanner.c' },
            branch = 'main',
            use_repo_queries = true,
          },
        },
      },
    },
    config = function(_, opts)
      if vim.fn.executable('tree-sitter') == 0 then
        UserUtil.lazyCoreUtil.error({
          'tree-sitter CLI is required for tree-sitter-manager.nvim.',
          'Install it manually: npm install -g tree-sitter-cli',
        })
        return
      end

      patch_tree_sitter_manager_installer()
      require('tree-sitter-manager').setup(opts)
      require('nvim-dap-repl-highlights').setup()

      vim.filetype.add({
        extension = {
          mdx = 'mdx',
        },
        pattern = {
          ['.*%.blade%.php'] = 'blade',
        },
      })
      vim.treesitter.language.register('markdown', 'mdx')
      UserUtil.treesitter.get_installed(true) -- initialize installed langs

      -- treesitter highlighting
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('miszo/native_treesitter', { clear = true }),
        callback = function(ev)
          local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
          if not lang or not UserUtil.treesitter.have(ft) then
            return
          end

          -- highlighting
          if UserUtil.treesitter.have(ft, 'highlights') then
            pcall(vim.treesitter.start, ev.buf)
          end

          -- indents
          if UserUtil.treesitter.have(ft, 'indents') then
            vim.api.nvim_set_option_value('indentexpr', 'v:lua.UserUtil.treesitter.indentexpr()', { scope = 'local' })
          end

          -- folds
          if UserUtil.treesitter.have(ft, 'folds') then
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
    end,
    dependencies = {
      'windwp/nvim-ts-autotag',
      'RRethy/nvim-treesitter-endwise',
      'nvim-treesitter/nvim-treesitter-context',
      { 'LiadOz/nvim-dap-repl-highlights' },
    },
  },

  {
    'folke/which-key.nvim',
    opts = {
      spec = {
        { ']f', desc = 'Next Function Start', mode = { 'n', 'x', 'o' } },
        { ']F', desc = 'Next Function End', mode = { 'n', 'x', 'o' } },
        { '[f', desc = 'Prev Function Start', mode = { 'n', 'x', 'o' } },
        { '[F', desc = 'Prev Function End', mode = { 'n', 'x', 'o' } },
        { ']c', desc = 'Next Class Start', mode = { 'n', 'x', 'o' } },
        { ']C', desc = 'Next Class End', mode = { 'n', 'x', 'o' } },
        { '[c', desc = 'Prev Class Start', mode = { 'n', 'x', 'o' } },
        { '[C', desc = 'Prev Class End', mode = { 'n', 'x', 'o' } },
        { ']a', desc = 'Next Parameter Start', mode = { 'n', 'x', 'o' } },
        { ']A', desc = 'Next Parameter End', mode = { 'n', 'x', 'o' } },
        { '[a', desc = 'Prev Parameter Start', mode = { 'n', 'x', 'o' } },
        { '[A', desc = 'Prev Parameter End', mode = { 'n', 'x', 'o' } },
      },
    },
    keys = function()
      local moves = {
        { ']f', '@function.outer', 1, 'start', 'Next Function Start' },
        { ']F', '@function.outer', 1, 'end', 'Next Function End' },
        { '[f', '@function.outer', -1, 'start', 'Prev Function Start' },
        { '[F', '@function.outer', -1, 'end', 'Prev Function End' },
        { ']c', '@class.outer', 1, 'start', 'Next Class Start' },
        { ']C', '@class.outer', 1, 'end', 'Next Class End' },
        { '[c', '@class.outer', -1, 'start', 'Prev Class Start' },
        { '[C', '@class.outer', -1, 'end', 'Prev Class End' },
        { ']a', '@parameter.inner', 1, 'start', 'Next Parameter Start' },
        { ']A', '@parameter.inner', 1, 'end', 'Next Parameter End' },
        { '[a', '@parameter.inner', -1, 'start', 'Prev Parameter Start' },
        { '[A', '@parameter.inner', -1, 'end', 'Prev Parameter End' },
      }
      local ret = {} ---@type LazyKeysSpec[]
      for _, move in ipairs(moves) do
        local key, capture, direction, edge, desc = unpack(move)
        ret[#ret + 1] = {
          key,
          function()
            if vim.wo.diff and key:find('[cC]') then
              return vim.cmd('normal! ' .. key)
            end
            UserUtil.treesitter.move_textobject({
              capture = capture,
              direction = direction,
              edge = edge,
            })
          end,
          desc = desc,
          mode = { 'n', 'x', 'o' },
          silent = true,
        }
      end
      return ret
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
    config = function()
      local tsj = require('treesj')
      tsj.setup({
        use_default_keymaps = false,
      })
      vim.keymap.set('n', '<leader>M', function()
        tsj.toggle({ split = { recursive = true } })
      end, { desc = 'Toggle split/join code block' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup({
        enable = true,
        max_lines = 6,
        trim_scope = 'outer',
      })
    end,
  },
  -- Chezmoi syntax highlighting
  {
    'alker0/chezmoi.vim',
  },
}
