local M = {}

-- In-memory cache: package_name -> VersionInfo
local cache = {}

---Get cached version info
---@param package_name string
---@return VersionInfo|nil
function M.get(package_name)
  local entry = cache[package_name]
  if not entry then
    return nil
  end

  -- Check if stale
  if M.is_stale(package_name) then
    return nil
  end

  return entry
end

---Set version info in cache
---@param package_name string
---@param version_info VersionInfo
function M.set(package_name, version_info)
  cache[package_name] = version_info
end

---Check if cached entry is stale
---@param package_name string
---@return boolean
function M.is_stale(package_name)
  local entry = cache[package_name]
  if not entry then
    return true
  end

  local config = require('local_plugins.pkg-version.config')
  local age = os.time() - entry.fetched_at
  return age > config.options.cache_ttl
end

---Invalidate cache for package
---@param package_name string|nil If nil, clear all
function M.invalidate(package_name)
  if package_name then
    cache[package_name] = nil
  else
    cache = {}
  end
end

---Clear all cache
function M.clear_all()
  cache = {}
end

---Get version info with caching and auto-fetch
---@param package_name string
---@param bufnr number Buffer number
---@param callback function(VersionInfo|nil, string|nil)
function M.get_or_fetch(package_name, bufnr, callback)
  -- Check cache first
  local cached = M.get(package_name)
  if cached then
    callback(cached, nil)
    return
  end

  -- Fetch from registry
  local registry = require('local_plugins.pkg-version.registry')
  registry.fetch_versions(package_name, bufnr, function(info, err)
    if info then
      M.set(package_name, info)
    end
    callback(info, err)
  end)
end

return M
