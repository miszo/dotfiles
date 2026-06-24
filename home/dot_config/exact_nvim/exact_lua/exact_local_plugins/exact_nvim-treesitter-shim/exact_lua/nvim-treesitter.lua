local M = {}

---@param kind string?
function M.get_installed(kind)
  if kind ~= nil and kind ~= 'parsers' then
    return {}
  end
  return vim.tbl_keys(UserUtil.treesitter.get_installed(true))
end

function M.setup() end

return M
