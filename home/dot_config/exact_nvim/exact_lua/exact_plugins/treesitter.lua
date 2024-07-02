return {
  { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'angular',
        'bash',
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
      require('nvim-treesitter.configs').setup(opts)

      -- MDX
      vim.filetype.add({
        extension = {
          mdx = 'mdx',
        },
      })
      vim.treesitter.language.register('markdown', 'mdx')
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
    init = function()
      vim.g['chezmoi#use_tmp_buffer'] = 1
      vim.g['chezmoi#source_dir_path'] = os.getenv('HOME') .. '/.local/share/chezmoi'
    end,
  },
}
