---@module 'lazy'
---@type LazySpec[]
return {
  { 'olexsmir/gopher.nvim', build = ':GoInstallDeps', opts = {} },
  {
    'fredrikaverpil/godoc.nvim',
    version = '*',
    dependencies = {
      { 'folke/snacks.nvim' },
    },
    opts = {
      adapters = {
        {
          name = 'go',
          opts = {
            command = 'GoDoc', -- the vim command to invoke Go documentation
            get_syntax_info = function()
              return {
                filetype = 'godoc', -- filetype of the documentation buffer
                language = 'godoc', -- tree-sitter parser, for syntax highlighting
              }
            end,
          },
        },
      },
      window = {
        type = 'vsplit', -- split | vsplit
      },
      picker = { type = 'snacks' },
    },
    keys = {
      { '<leader>gD', '<cmd>GoDoc<cr>', desc = 'GoDoc' },
    },
    build = 'go install github.com/lotusirous/gostdsym/stdsym@latest', -- optional
  },
}
