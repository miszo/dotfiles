---@module "lazy"
---@type LazySpec[]
return {
  {
    'folke/lazydev.nvim',
    dependencies = {
      { 'Bilal2453/luvit-meta', lazy = true },
    },
    ft = 'lua',
    cmd = 'LazyDev',
    opts = function(_, opts)
      vim.list_extend(opts.library, {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = '${3rd}/luassert/library', words = { 'assert' } },
        { path = '${3rd}/busted/library', words = { 'describe' } },
        { path = 'lazy.nvim', words = { 'LazySpec' } },
      })
    end,
  },
}
