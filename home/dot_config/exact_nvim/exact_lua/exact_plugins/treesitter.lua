---@module "lazy"
---@type LazySpec[]
return {
  { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      require('nvim-treesitter.install').update({ with_sync = true })()
    end,
    dependencies = {
      'windwp/nvim-ts-autotag',
      'RRethy/nvim-treesitter-endwise',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
      'LiadOz/nvim-dap-repl-highlights',
    },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'angular',
        'bash',
        'blade',
        'cpp',
        'css',
        'dockerfile',
        'gitignore',
        'go',
        'graphql',
        'html',
        'http',
        'javascript',
        'json',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'mermaid',
        'php',
        'prisma',
        'regex',
        'ruby',
        'rust',
        'scss',
        'ssh_config',
        'sql',
        'swift',
        'svelte',
        'toml',
        'tsx',
        'typescript',
        'yaml',
        'vimdoc',
        'vue',
      })
      opts.autoinstall = true
      opts.highlight = { enable = true }
      opts.indent = { enable = true }

      -- https://github.com/nvim-treesitter/playground#query-linter
      opts.query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { 'BufWrite', 'CursorHold' },
      }
      opts.playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = true, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
        },
      }
    end,
    config = function(_, opts)
      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

      parser_config.blade = {
        install_info = {
          url = 'https://github.com/EmranMR/tree-sitter-blade',
          files = { 'src/parser.c' },
          branch = 'main',
        },
        filetype = 'blade',
      }

      -- MDX
      vim.filetype.add({
        extension = {
          mdx = 'mdx',
        },
        pattern = {
          ['.*%.blade%.php'] = 'blade',
        },
      })
      vim.treesitter.language.register('markdown', 'mdx')

      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
