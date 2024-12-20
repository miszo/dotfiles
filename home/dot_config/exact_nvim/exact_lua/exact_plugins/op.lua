---@type LazySpec[]
return {
  {
    'mrjones2014/op.nvim',
    build = 'make install',
    cmd = {
      'OpSignin',
      'OpSignout',
      'OpWhoami',
      'OpCreate',
      'OpView',
      'OpEdit',
      'OpOpen',
      'OpInsert',
      'OpNote',
      'OpSidebar',
      'OpAnalyzeBuffer',
    },
    config = function()
      require('op').setup()
    end,
  },
}
