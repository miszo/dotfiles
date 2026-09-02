local cmp = require('util.cmp')
local config_files = require('util.config_files')
local diagnostic = require('util.diagnostic')
local formatting = require('util.formatting')
local icons = require('util.icons')
local lsp = require('util.lsp')
local mason = require('util.mason')
local mini = require('util.mini')
local nx = require('util.nx')
local plugins = require('util.plugins')
local root = require('util.root')
local statusline = require('util.statusline')
local treesitter = require('util.treesitter')
local zen = require('util.zen')

local M = {
  cmp = cmp,
  config_files = config_files,
  diagnostic = diagnostic,
  formatting = formatting,
  icons = icons,
  lsp = lsp,
  mason = mason,
  mini = mini,
  nx = nx,
  plugins = plugins,
  root = root,
  statusline = statusline,
  treesitter = treesitter,
  zen = zen,
}

root.setup()

_G.UserUtil = M

return M
