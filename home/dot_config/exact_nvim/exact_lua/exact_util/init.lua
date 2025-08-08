local formatting = require('util.formatting')
local icons = require('util.icons')
local mason = require('util.mason')
local mini = require('util.mini')
local lsp = require('util.lsp')
local plugins = require('util.plugins')
local statusline = require('util.statusline')

local M = {
  formatting = formatting,
  icons = icons,
  mason = mason,
  mini = mini,
  lsp = lsp,
  plugins = plugins,
  statusline = statusline,
}

_G.UserUtil = M

return M
