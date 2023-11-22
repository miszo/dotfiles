vim.treesitter.language.register('markdown', 'mdx')
return {
  { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'bash',
        'cpp',
        'css',
        'dockerfile',
        'gitignore',
        'graphql',
        'html',
        'http',
        'javascript',
        'json',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'regex',
        'ruby',
        'rust',
        'scss',
        'sql',
        'svelte',
        'toml',
        'tsx',
        'typescript',
        'yaml',
        'vimdoc',
      })
    end,
  },
}
