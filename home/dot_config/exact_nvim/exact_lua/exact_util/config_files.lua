local M = {}

---@type table<string>
local extensions = {
  'js',
  'ts',
  'mjs',
  'mts',
  'cjs',
  'cts',
}

---@param tool_name string
---@return table<string>
function M.js_config_filenames(tool_name)
  local config_filenames = {} ---@type table<string>
  for _, ext in ipairs(extensions) do
    table.insert(config_filenames, tool_name .. '.config.' .. ext)
  end
  return config_filenames
end

return M
