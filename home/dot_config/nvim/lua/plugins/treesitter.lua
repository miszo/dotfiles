vim.treesitter.language.register('markdown', 'mdx')
return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'bash',
        'css',
        'dockerfile',
        'graphql',
        'html',
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
        'toml',
        'tsx',
        'typescript',
        'yaml',
        'vimdoc',
      })
    end,
  },
  { 'nvim-treesitter/playground' },
}
