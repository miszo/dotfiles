local M = {}

-- Namespace for virtual text
local ns_id = vim.api.nvim_create_namespace('miszo/pkg-version')

---Compare semver versions
---@param current string Current version from package.json
---@param latest string Latest version from registry
---@return boolean is_outdated
local function is_outdated(current, latest)
  -- Remove leading ^ or ~ or >= etc.
  local clean_current = current:gsub('^[~^>=<]+', '')

  -- Simple semver comparison (not perfect but works for most cases)
  if clean_current == latest then
    return false
  end

  -- If versions are different, consider outdated
  -- TODO: Implement proper semver comparison if needed
  return true
end

---Show version info for a dependency
---@param bufnr number Buffer number
---@param dependency Dependency
---@param version_info VersionInfo
function M.show(bufnr, dependency, version_info)
  local config = require('local_plugins.pkg-version.config')

  if not config.options.virtual_text.enabled then
    return
  end

  local latest = version_info.latest
  local current = dependency.version:gsub('^[~^>=<]+', '')

  local outdated = is_outdated(dependency.version, latest)

  -- Hide up-to-date packages if configured
  if config.options.virtual_text.hide_up_to_date and not outdated then
    return
  end

  local text, hl_group

  if outdated then
    text = string.format('%s%s', config.options.virtual_text.prefix, latest)
    hl_group = config.options.virtual_text.highlight.outdated
  else
    text = string.format('%s%s ✓', config.options.virtual_text.prefix, latest)
    hl_group = config.options.virtual_text.highlight.up_to_date
  end

  vim.api.nvim_buf_set_extmark(bufnr, ns_id, dependency.line, 0, {
    virt_text = { { text, hl_group } },
    virt_text_pos = 'eol',
    hl_mode = 'combine',
  })
end

---Show error for a dependency
---@param bufnr number Buffer number
---@param dependency Dependency
---@param error_msg string Error message
function M.show_error(bufnr, dependency, error_msg)
  local config = require('local_plugins.pkg-version.config')

  if not config.options.virtual_text.enabled then
    return
  end

  local text = config.options.virtual_text.prefix .. '✗ ' .. error_msg
  local hl_group = config.options.virtual_text.highlight.error

  vim.api.nvim_buf_set_extmark(bufnr, ns_id, dependency.line, 0, {
    virt_text = { { text, hl_group } },
    virt_text_pos = 'eol',
    hl_mode = 'combine',
  })
end

---Hide virtual text for a specific line
---@param bufnr number Buffer number
---@param line number? Line number (0-indexed), if nil clear all
function M.hide(bufnr, line)
  if line then
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, line, line + 1)
  else
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
  end
end

---Clear all virtual text in buffer
---@param bufnr number Buffer number
function M.clear(bufnr)
  M.hide(bufnr)
end

---Refresh virtual text for all dependencies
---@param bufnr number Buffer number
function M.refresh(bufnr)
  M.clear(bufnr)

  local parser = require('local_plugins.pkg-version.parser')
  local cache = require('local_plugins.pkg-version.cache')

  local dependencies = parser.get_all_dependencies(bufnr)

  -- Fetch all outdated info in a single call
  local registry = require('local_plugins.pkg-version.registry')
  registry.fetch_all_outdated(bufnr, function(data, err)
    if err then
      vim.notify('Failed to fetch package versions: ' .. err, vim.log.levels.WARN)
      return
    end

    -- Now show virtual text for each dependency
    for _, dep in ipairs(dependencies) do
      local pkg_info = data[dep.name]
      if pkg_info then
        local version_info = {
          package = dep.name,
          current = pkg_info.current or '',
          wanted = pkg_info.wanted or pkg_info.current or '',
          latest = pkg_info.latest or pkg_info.wanted or pkg_info.current or '',
          fetched_at = os.time(),
        }
        M.show(bufnr, dep, version_info)
      end
    end
  end)
end

return M
