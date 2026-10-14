local dap = require('config.dap')
local f_types = require('config.filetypes')
local icons = require('config.icons')
local kind_filter = require('config.kind_filter')
local mason = require('config.mason')
local tailwind = require('config.tailwind')
local treesitter = require('config.treesitter')

local M = {
  buftypes = f_types.buftypes,
  dap = dap,
  filetypes = f_types.filetypes,
  icons = icons,
  kind_filter = kind_filter,
  mason = mason,
  tailwind = tailwind,
  treesitter = treesitter,
}

_G.UserConfig = M

return M
