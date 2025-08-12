local formatting = require('util.formatting')
local cmp = require('util.cmp')
local icons = require('util.icons')
local mason = require('util.mason')
local mini = require('util.mini')
local lsp = require('util.lsp')
local plugins = require('util.plugins')
local statusline = require('util.statusline')
local ui = require('util.ui')

local M = {
  formatting = formatting,
  cmp = cmp,
  icons = icons,
  mason = mason,
  mini = mini,
  lsp = lsp,
  plugins = plugins,
  statusline = statusline,
  ui = ui,
}

_G.UserUtil = M

return M
