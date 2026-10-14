vim.o.cmdheight = 0

require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = 'msg',
    pager = { height = 1 },
    msg = { height = 0.5, timeout = 4500 },
    dialog = { height = 0.5 },
    cmd = { height = 0.5 },
  },
})

require('core.setup_util')
require('core.options')
require('core.autocmds')

require('core.lazy')
require('core.keymaps')
