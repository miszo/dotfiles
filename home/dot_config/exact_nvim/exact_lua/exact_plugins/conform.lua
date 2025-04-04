local prettier_with_lsp = { 'prettier', lsp_format = 'first' }

---@module "lazy"
---@type LazySpec[]
return {
  {
    'stevearc/conform.nvim',
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        ruby = { vim.g.lazyvim_ruby_formatter },
        eruby = { 'prettier' },
        javascript = prettier_with_lsp,
        javascriptreact = prettier_with_lsp,
        typescript = prettier_with_lsp,
        typescriptreact = prettier_with_lsp,
      },
    },
  },
}
