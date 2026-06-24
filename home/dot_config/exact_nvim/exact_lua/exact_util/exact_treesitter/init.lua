local core = require('util.treesitter.core')
local indent = require('util.treesitter.indent')
local textobjects = require('util.treesitter.textobjects')

local M = {}

for key, value in pairs(core) do
  M[key] = value
end

function M.indentexpr()
  return indent.get_indent(vim.v.lnum)
end

M.move_textobject = textobjects.move_textobject

return M
