local dap = require('config.configs.dap')
local f_types = require('config.configs.filetypes')
local icons = require('config.configs.icons')
local kind_filter = require('config.configs.kind_filter')
local mason = require('config.configs.mason')
local tailwind = require('config.configs.tailwind')
local treesitter = require('config.configs.treesitter')

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
