local M = {}

---@param kind string?
function M.get_installed(kind)
  return require('nvim-treesitter').get_installed(kind)
end

return M
