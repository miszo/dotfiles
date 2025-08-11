---@module 'lazy'
---@type LazySpec[]
return {
  {
    'numToStr/Navigator.nvim',
    keys = {
      {
        '<C-w>h',
        '<C-\\><C-n><cmd>NavigatorLeft<cr>',
        desc = 'NavigatorLeft',
        silent = true,
        mode = { 'v', 'n', 'i', 't' },
      },
      {
        '<C-w>l',
        '<C-\\><C-n><cmd>NavigatorRight<cr>',
        desc = 'NavigatorRight',
        silent = true,
        mode = { 'v', 'n', 'i', 't' },
      },
      {
        '<C-w>k',
        '<C-\\><C-n><cmd>NavigatorUp<cr>',
        desc = 'NavigatorUp',
        silent = true,
        mode = { 'v', 'n', 'i', 't' },
      },
      {
        '<C-w>j',
        '<C-\\><C-n><cmd>NavigatorDown<cr>',
        desc = 'NavigatorDown',
        silent = true,
        mode = { 'v', 'n', 'i', 't' },
      },
    },
    config = function(_, opts)
      require('Navigator').setup(opts)
    end,
  },
}
