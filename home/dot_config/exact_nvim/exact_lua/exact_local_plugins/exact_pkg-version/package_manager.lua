local M = {}

-- Cache detection results per project root (workspace)
local cache = {}

---Find workspace root (for monorepos, find the root with lockfile)
---@param bufnr number|nil Buffer number (default: current buffer)
---@return string|nil workspace_root Path to workspace root or nil
local function find_workspace_root(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  if filepath == '' then
    return nil
  end

  local dir = vim.fn.fnamemodify(filepath, ':h')
  local config = require('local_plugins.pkg-version.config')

  -- Search upward for lockfile
  while dir ~= '/' do
    for _, entry in ipairs(config.options.package_managers) do
      local lockfile_path = dir .. '/' .. entry.file
      if vim.fn.filereadable(lockfile_path) == 1 then
        return dir
      end
    end
    dir = vim.fn.fnamemodify(dir, ':h')
  end

  -- Fallback: find nearest package.json
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

---Detect package manager from lockfiles in workspace root
---@param workspace_root string Path to workspace root
---@return string package_manager 'npm' | 'yarn' | 'pnpm' | 'bun'
local function detect_from_lockfiles(workspace_root)
  local config = require('local_plugins.pkg-version.config')

  for _, entry in ipairs(config.options.package_managers) do
    local lockfile_path = workspace_root .. '/' .. entry.file
    if vim.fn.filereadable(lockfile_path) == 1 then
      -- Verify the package manager is actually installed
      if vim.fn.executable(entry.manager) == 1 then
        return entry.manager
      end
    end
  end

  -- Fallback to configured default
  return config.options.fallback_manager
end

---Get package manager for current buffer (with caching)
---@param bufnr number|nil Buffer number (default: current buffer)
---@return string package_manager 'npm' | 'yarn' | 'pnpm' | 'bun'
function M.get_package_manager(bufnr)
  local workspace_root = find_workspace_root(bufnr)

  if not workspace_root then
    local config = require('local_plugins.pkg-version.config')
    return config.options.fallback_manager
  end

  -- Check cache
  if cache[workspace_root] then
    return cache[workspace_root]
  end

  -- Detect and cache
  local manager = detect_from_lockfiles(workspace_root)
  cache[workspace_root] = manager

  return manager
end

---Detect package manager (bypasses cache, re-detects)
---@param bufnr number|nil Buffer number (default: current buffer)
---@return string package_manager 'npm' | 'yarn' | 'pnpm' | 'bun'
function M.detect_package_manager(bufnr)
  local workspace_root = find_workspace_root(bufnr)

  if not workspace_root then
    local config = require('local_plugins.pkg-version.config')
    return config.options.fallback_manager
  end

  local manager = detect_from_lockfiles(workspace_root)
  cache[workspace_root] = manager

  return manager
end

---Clear cache for a workspace or all workspaces
---@param workspace_root string|nil Specific workspace root, or nil to clear all
function M.clear_cache(workspace_root)
  if workspace_root then
    cache[workspace_root] = nil
  else
    cache = {}
  end
end

---Get install command for package manager
---@param manager string Package manager name
---@param package_name string Package name (with optional version)
---@param opts table? Options (dev = boolean, peer = boolean)
---@return string[] command Command as array
function M.get_install_command(manager, package_name, opts)
  opts = opts or {}

  if manager == 'npm' then
    local cmd = { 'npm', 'install' }
    if opts.dev then
      table.insert(cmd, '--save-dev')
    elseif opts.peer then
      table.insert(cmd, '--save-peer')
    end
    table.insert(cmd, package_name)
    return cmd
  elseif manager == 'yarn' then
    local cmd = { 'yarn', 'add' }
    if opts.dev then
      table.insert(cmd, '--dev')
    elseif opts.peer then
      table.insert(cmd, '--peer')
    end
    table.insert(cmd, package_name)
    return cmd
  elseif manager == 'pnpm' then
    local cmd = { 'pnpm', 'add' }
    if opts.dev then
      table.insert(cmd, '--save-dev')
    elseif opts.peer then
      table.insert(cmd, '--save-peer')
    end
    table.insert(cmd, package_name)
    return cmd
  elseif manager == 'bun' then
    local cmd = { 'bun', 'add' }
    if opts.dev then
      table.insert(cmd, '--development')
    elseif opts.peer then
      table.insert(cmd, '--peer')
    end
    table.insert(cmd, package_name)
    return cmd
  end

  return { 'npm', 'install', package_name }
end

---Get update command for package manager
---@param manager string Package manager name
---@param package_name string Package name
---@param to_latest boolean? If true, update to latest (ignoring semver), default false
---@return string[] command Command as array
function M.get_update_command(manager, package_name, to_latest)
  if to_latest then
    -- Force update to latest version by using install/add with @latest
    if manager == 'npm' then
      return { 'npm', 'install', package_name .. '@latest' }
    elseif manager == 'yarn' then
      return { 'yarn', 'upgrade', package_name, '--latest' }
    elseif manager == 'pnpm' then
      return { 'pnpm', 'update', package_name, '--latest' }
    elseif manager == 'bun' then
      return { 'bun', 'update', package_name, '--latest' }
    end
    return { 'npm', 'install', package_name .. '@latest' }
  else
    -- Respect semver range in package.json
    if manager == 'npm' then
      return { 'npm', 'update', package_name }
    elseif manager == 'yarn' then
      return { 'yarn', 'upgrade', package_name }
    elseif manager == 'pnpm' then
      return { 'pnpm', 'update', package_name }
    elseif manager == 'bun' then
      return { 'bun', 'update', package_name }
    end
    return { 'npm', 'update', package_name }
  end
end

---Get delete command for package manager
---@param manager string Package manager name
---@param package_name string Package name
---@return string[] command Command as array
function M.get_delete_command(manager, package_name)
  if manager == 'npm' then
    return { 'npm', 'uninstall', package_name }
  elseif manager == 'yarn' then
    return { 'yarn', 'remove', package_name }
  elseif manager == 'pnpm' then
    return { 'pnpm', 'remove', package_name }
  elseif manager == 'bun' then
    return { 'bun', 'remove', package_name }
  end

  return { 'npm', 'uninstall', package_name }
end

---Get info command for package manager (to fetch versions)
---@param manager string Package manager name
---@param package_name string Package name
---@return string[] command Command as array
function M.get_info_command(manager, package_name)
  if manager == 'npm' then
    return { 'npm', 'view', package_name, 'versions', 'dist-tags', '--json' }
  elseif manager == 'yarn' then
    return { 'yarn', 'info', package_name, 'versions', 'dist-tags', '--json' }
  elseif manager == 'pnpm' then
    return { 'pnpm', 'view', package_name, 'versions', 'dist-tags', '--json' }
  elseif manager == 'bun' then
    return { 'bun', 'pm', 'view', package_name, 'versions', 'dist-tags', '--json' }
  end

  return { 'npm', 'view', package_name, 'versions', 'dist-tags', '--json' }
end

return M
