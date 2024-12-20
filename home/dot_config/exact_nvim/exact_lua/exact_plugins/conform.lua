---@type LazySpec[]
return {
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        ruby = { vim.g.lazyvim_ruby_formatter },
        eruby = { 'prettier' },
      },
    },
  },
}
