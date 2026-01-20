local M = {}

---@class Dependency
---@field name string Package name
---@field version string Version spec from package.json
---@field line number Line number (0-indexed)
---@field type 'dependencies'|'devDependencies'|'peerDependencies'|'optionalDependencies'

---@class ParsedPackage
---@field dependencies Dependency[]
---@field valid boolean
---@field error string?

---Check if buffer is a package.json file
---@param bufnr number|nil
---@return boolean
function M.is_package_json(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  return filename:match('/package%.json$') ~= nil
end

---Parse package.json buffer
---@param bufnr number|nil Buffer number (default: current buffer)
---@return ParsedPackage
function M.parse_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local result = {
    dependencies = {},
    valid = false,
    error = nil,
  }

  if not M.is_package_json(bufnr) then
    result.error = 'Not a package.json file'
    return result
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content = table.concat(lines, '\n')

  -- Parse JSON
  local ok, data = pcall(vim.json.decode, content)
  if not ok then
    result.error = 'Invalid JSON: ' .. tostring(data)
    return result
  end

  -- Extract dependencies
  local dep_types = {
    'dependencies',
    'devDependencies',
    'peerDependencies',
    'optionalDependencies',
  }

  for _, dep_type in ipairs(dep_types) do
    if data[dep_type] and type(data[dep_type]) == 'table' then
      -- Find the line number for each dependency
      for pkg_name, version in pairs(data[dep_type]) do
        -- Search for the line containing this package
        for line_num, line in ipairs(lines) do
          -- Match: "package-name": "version"
          local pattern = string.format('"%s"%s*:%s*"', pkg_name:gsub('%-', '%%-'), '%s', '%s')
          if line:match(pattern) then
            table.insert(result.dependencies, {
              name = pkg_name,
              version = version,
              line = line_num - 1, -- 0-indexed
              type = dep_type,
            })
            break
          end
        end
      end
    end
  end

  result.valid = true
  return result
end

---Get dependency at specific line
---@param bufnr number|nil Buffer number (default: current buffer)
---@param line number Line number (1-indexed)
---@return Dependency?
function M.get_dependency_at_line(bufnr, line)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local parsed = M.parse_buffer(bufnr)

  if not parsed.valid then
    return nil
  end

  -- Convert to 0-indexed
  line = line - 1

  for _, dep in ipairs(parsed.dependencies) do
    if dep.line == line then
      return dep
    end
  end

  return nil
end

---Get all dependencies
---@param bufnr number|nil Buffer number (default: current buffer)
---@return Dependency[]
function M.get_all_dependencies(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local parsed = M.parse_buffer(bufnr)

  if not parsed.valid then
    return {}
  end

  return parsed.dependencies
end

---Check if buffer is valid package.json
---@param bufnr number|nil
---@return boolean, string?
function M.is_valid_package_json(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local parsed = M.parse_buffer(bufnr)
  return parsed.valid, parsed.error
end

return M
