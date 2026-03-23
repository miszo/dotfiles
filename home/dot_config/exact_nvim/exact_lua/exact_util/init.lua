local cmp = require('util.cmp')
local formatting = require('util.formatting')
local icons = require('util.icons')
local lsp = require('util.lsp')
local mason = require('util.mason')
local mini = require('util.mini')
local nx = require('util.nx')
local plugins = require('util.plugins')
local statusline = require('util.statusline')
local treesitter = require('util.treesitter')
local zen = require('util.zen')

local M = {
  cmp = cmp,
  formatting = formatting,
  icons = icons,
  lsp = lsp,
  mason = mason,
  mini = mini,
  nx = nx,
  plugins = plugins,
  statusline = statusline,
  treesitter = treesitter,
  zen = zen,
}

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

_G.UserUtil = M

return M
