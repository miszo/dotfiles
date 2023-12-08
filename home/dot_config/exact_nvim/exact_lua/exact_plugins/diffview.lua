return {

  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  keys = {
    {
      '<leader>gd',
      function()
        local lib = require('diffview.lib')
        local view = lib.get_current_view()
        if view then
          -- Current tabpage is a Diffview; close it
          vim.cmd(':DiffviewClose')
        else
          -- No open Diffview exists: open a new one
          vim.cmd(':DiffviewOpen')
        end
      end,
      desc = 'Diff view toggle',
    },
  },
}
