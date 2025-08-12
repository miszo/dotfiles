---@module 'lazy'
---@type LazySpec[]
return {
  {
    'TymekDev/freeze.nvim',
    cmd = 'Freeze',
    ---@module "freeze"
    ---@type freeze.Options
    opts = {
      config = 'user',
      ['font.family'] = 'MonoLisa Variable',
      theme = function()
        return require('freeze.themes').catppuccin_mocha
      end,
    },
  },
}
