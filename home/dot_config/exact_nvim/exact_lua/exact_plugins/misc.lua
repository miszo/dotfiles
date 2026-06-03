---@module 'lazy'
---@type LazySpec[]
return {
  -- measure startuptime
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  {
    'b0o/SchemaStore.nvim',
    lazy = true,
    version = false, -- last release is way too old
  },
  -- library used by other plugins
  { 'nvim-lua/plenary.nvim', lazy = true },
}
