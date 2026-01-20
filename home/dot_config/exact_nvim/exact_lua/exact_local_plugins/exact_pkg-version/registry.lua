local M = {}

---@class VersionInfo
---@field package string Package name
---@field current string Current version
---@field wanted string Wanted version (respects semver range)
---@field latest string Latest stable version
---@field fetched_at number Timestamp

-- Cache for all outdated data (single fetch for all packages)
local outdated_cache = {
  data = nil,
  fetched_at = 0,
}

---Get project root from buffer
---@param bufnr number Buffer number
---@return string|nil
local function get_project_root(bufnr)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == '' then
    return nil
  end

  local package_json = vim.fs.find('package.json', {
    path = filepath,
    upward = true,
    type = 'file',
  })[1]

  if package_json then
    return vim.fn.fnamemodify(package_json, ':h')
  end

  return nil
end

---Fetch all outdated packages info using npm outdated
---@param bufnr number Buffer number for project root detection
---@param callback function(table|nil, string|nil) Callback with outdated data or error
function M.fetch_all_outdated(bufnr, callback)
  local config = require('local_plugins.pkg-version.config')
  
  -- Check cache first
  local age = os.time() - outdated_cache.fetched_at
  if outdated_cache.data and age < config.options.cache_ttl then
    callback(outdated_cache.data, nil)
    return
  end

  local project_root = get_project_root(bufnr)
  if not project_root then
    callback(nil, 'Could not find package.json')
    return
  end

  -- Always use npm outdated --json (works regardless of package manager)
  -- Use --no-auth to bypass authentication issues with public packages
  local cmd = { 'npm', 'outdated', '--json', '--no-auth' }

  vim.system(cmd, {
    cwd = project_root,
    text = true,
    timeout = config.options.registry_timeout,
  }, function(result)
    vim.schedule(function()
      -- npm outdated returns exit code 1 when there are outdated packages
      -- So we check for both 0 and 1
      if result.code ~= 0 and result.code ~= 1 then
        callback(nil, 'Failed to fetch outdated info: ' .. (result.stderr or 'Unknown error'))
        return
      end

      -- Empty result means all packages are up to date
      if result.stdout == '' or result.stdout == '{}' then
        outdated_cache.data = {}
        outdated_cache.fetched_at = os.time()
        callback({}, nil)
        return
      end

      local ok, data = pcall(vim.json.decode, result.stdout)
      if not ok then
        callback(nil, 'Failed to parse outdated info: ' .. tostring(data))
        return
      end

      -- Cache the result
      outdated_cache.data = data
      outdated_cache.fetched_at = os.time()

      callback(data, nil)
    end)
  end)
end

---Get version info for a specific package
---@param package_name string
---@param bufnr number Buffer number
---@param callback function(VersionInfo|nil, string|nil) Callback with version info or error
function M.fetch_versions(package_name, bufnr, callback)
  M.fetch_all_outdated(bufnr, function(data, err)
    if err then
      callback(nil, err)
      return
    end

    local pkg_info = data[package_name]
    if not pkg_info then
      -- Package is up to date or not found
      callback(nil, nil)
      return
    end

    local version_info = {
      package = package_name,
      current = pkg_info.current or '',
      wanted = pkg_info.wanted or pkg_info.current or '',
      latest = pkg_info.latest or pkg_info.wanted or pkg_info.current or '',
      fetched_at = os.time(),
    }

    callback(version_info, nil)
  end)
end

---Clear the outdated cache
function M.clear_cache()
  outdated_cache.data = nil
  outdated_cache.fetched_at = 0
end

---Fetch all available versions for a package (for version picker)
---@param package_name string
---@param bufnr number Buffer number  
---@param callback function(table|nil, string|nil) Callback with version list or error
function M.fetch_all_versions(package_name, bufnr, callback)
  local config = require('local_plugins.pkg-version.config')
  local project_root = get_project_root(bufnr)
  
  if not project_root then
    callback(nil, 'Could not find package.json')
    return
  end

  -- Use npm view to get all versions (with --no-auth for public packages)
  local cmd = { 'npm', 'view', package_name, 'versions', '--json', '--no-auth' }

  vim.system(cmd, {
    cwd = project_root,
    text = true,
    timeout = config.options.registry_timeout,
  }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        callback(nil, 'Failed to fetch versions: ' .. (result.stderr or 'Unknown error'))
        return
      end

      local ok, versions = pcall(vim.json.decode, result.stdout)
      if not ok then
        callback(nil, 'Failed to parse versions: ' .. tostring(versions))
        return
      end

      -- npm view returns a single string if there's only one version
      if type(versions) == 'string' then
        versions = { versions }
      end

      callback({
        package = package_name,
        versions = versions,
        latest = versions[#versions],
        fetched_at = os.time(),
      }, nil)
    end)
  end)
end

return M
