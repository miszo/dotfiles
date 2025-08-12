local M = {}

local function get_mason_path()
  return vim.fs.normalize(vim.fs.joinpath(vim.fn.stdpath('data'), 'mason'))
end

---@param name string
function M.get_package_install_path(name)
  return vim.fs.normalize(vim.fs.joinpath(get_mason_path(), '/packages/', name))
end

function M.get_package_bin_path(name)
  return vim.fs.normalize(vim.fs.joinpath(get_mason_path(), '/bin/', name))
end

return M
