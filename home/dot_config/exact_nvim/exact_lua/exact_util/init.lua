local formatting = require('util.formatting')
local cmp = require('util.cmp')
local icons = require('util.icons')
local mason = require('util.mason')
local mini = require('util.mini')
local lsp = require('util.lsp')
local plugins = require('util.plugins')
local statusline = require('util.statusline')
local treesitter = require('util.treesitter')

local M = {
  formatting = formatting,
  cmp = cmp,
  icons = icons,
  mason = mason,
  mini = mini,
  lsp = lsp,
  plugins = plugins,
  statusline = statusline,
  treesitter = treesitter,
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
