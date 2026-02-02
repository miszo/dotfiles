local M = {}

---Setup the plugin
---@param user_config PkgVersionConfig?
function M.setup(user_config)
  local config = require('local_plugins.pkg-version.config')
  config.setup(user_config)

  -- Setup autocmds
  local augroup = vim.api.nvim_create_augroup('miszo/PkgVersion', { clear = true })

  -- Auto-show on package.json open
  if config.options.autostart then
    vim.api.nvim_create_autocmd('BufEnter', {
      group = augroup,
      pattern = '*/package.json',
      callback = function(ev)
        M.show(ev.buf)
      end,
      desc = 'Auto-show package versions',
    })
  end

  -- Auto-refresh on save
  if config.options.auto_refresh_on_save then
    vim.api.nvim_create_autocmd('BufWritePost', {
      group = augroup,
      pattern = '*/package.json',
      callback = function(ev)
        local cache = require('local_plugins.pkg-version.cache')
        cache.clear_all()
        M.refresh(ev.buf)
      end,
      desc = 'Refresh package versions on save',
    })
  end

  -- Create user commands
  vim.api.nvim_create_user_command('PkgShow', function()
    M.show()
  end, { desc = 'Show package versions' })

  vim.api.nvim_create_user_command('PkgHide', function()
    M.hide()
  end, { desc = 'Hide package versions' })

  vim.api.nvim_create_user_command('PkgToggle', function()
    M.toggle()
  end, { desc = 'Toggle package versions' })

  vim.api.nvim_create_user_command('PkgRefresh', function()
    M.refresh()
  end, { desc = 'Refresh package versions' })

  vim.api.nvim_create_user_command('PkgInstall', function(opts)
    if opts.args and opts.args ~= '' then
      M.install(opts.args)
    else
      M.install()
    end
  end, { nargs = '?', desc = 'Install package' })

  vim.api.nvim_create_user_command('PkgUpdate', function()
    M.update()
  end, { desc = 'Update package on current line' })

  vim.api.nvim_create_user_command('PkgDelete', function()
    M.delete()
  end, { desc = 'Delete package on current line' })

  vim.api.nvim_create_user_command('PkgChangeVersion', function()
    M.change_version()
  end, { desc = 'Change version of package on current line' })

  vim.api.nvim_create_user_command('PkgInfo', function()
    M.show_package_manager_info()
  end, { desc = 'Show package manager info' })
end

---Show package versions inline
---@param bufnr number?
function M.show(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local parser = require('local_plugins.pkg-version.parser')
  if not parser.is_package_json(bufnr) then
    vim.notify('Not a package.json file', vim.log.levels.WARN)
    return
  end

  local vtext = require('local_plugins.pkg-version.ui.virtual_text')
  vtext.refresh(bufnr)
end

---Hide package versions
---@param bufnr number?
function M.hide(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local vtext = require('local_plugins.pkg-version.ui.virtual_text')
  vtext.clear(bufnr)
end

---Toggle package versions
---@param bufnr number?
function M.toggle(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local config = require('local_plugins.pkg-version.config')

  config.options.virtual_text.enabled = not config.options.virtual_text.enabled

  if config.options.virtual_text.enabled then
    M.show(bufnr)
  else
    M.hide(bufnr)
  end
end

---Refresh package versions (force re-fetch)
---@param bufnr number?
function M.refresh(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local cache = require('local_plugins.pkg-version.cache')
  cache.clear_all()
  M.show(bufnr)
end

---Install a package
---@param package_name string? Package name (prompts if not provided)
function M.install(package_name)
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = require('local_plugins.pkg-version.parser')

  if not parser.is_package_json(bufnr) then
    vim.notify('Not a package.json file', vim.log.levels.WARN)
    return
  end

  if not package_name then
    -- Prompt for package name
    vim.ui.input({ prompt = 'Package name: ' }, function(input)
      if not input or input == '' then
        return
      end
      M.install(input)
    end)
    return
  end

  -- Ask for dependency type
  local picker = require('local_plugins.pkg-version.ui.picker')
  picker.select_dependency_type(function(dep_type)
    if not dep_type then
      return
    end

    local opts = {
      dev = dep_type == 'dev',
      peer = dep_type == 'peer',
      bufnr = bufnr,
    }

    local ops = require('local_plugins.pkg-version.operations')
    ops.install(package_name, opts, function(success, err)
      if not success then
        vim.notify('Install failed: ' .. (err or 'Unknown error'), vim.log.levels.ERROR)
      end
    end)
  end)
end

---Update package on current line
function M.update()
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = require('local_plugins.pkg-version.parser')

  if not parser.is_package_json(bufnr) then
    vim.notify('Not a package.json file', vim.log.levels.WARN)
    return
  end

  local line = vim.fn.line('.')
  local dep = parser.get_dependency_at_line(bufnr, line)

  if not dep then
    vim.notify('No package on current line', vim.log.levels.WARN)
    return
  end

  local ops = require('local_plugins.pkg-version.operations')
  ops.update(dep.name, bufnr, function(success, err)
    if not success then
      vim.notify('Update failed: ' .. (err or 'Unknown error'), vim.log.levels.ERROR)
    end
  end)
end

---Delete package on current line
function M.delete()
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = require('local_plugins.pkg-version.parser')

  if not parser.is_package_json(bufnr) then
    vim.notify('Not a package.json file', vim.log.levels.WARN)
    return
  end

  local line = vim.fn.line('.')
  local dep = parser.get_dependency_at_line(bufnr, line)

  if not dep then
    vim.notify('No package on current line', vim.log.levels.WARN)
    return
  end

  local ops = require('local_plugins.pkg-version.operations')
  ops.delete(dep.name, bufnr, function(success, err)
    if not success then
      vim.notify('Delete failed: ' .. (err or 'Unknown error'), vim.log.levels.ERROR)
    end
  end)
end

---Change version of package on current line
function M.change_version()
  local bufnr = vim.api.nvim_get_current_buf()
  local parser = require('local_plugins.pkg-version.parser')

  if not parser.is_package_json(bufnr) then
    vim.notify('Not a package.json file', vim.log.levels.WARN)
    return
  end

  local line = vim.fn.line('.')
  local dep = parser.get_dependency_at_line(bufnr, line)

  if not dep then
    vim.notify('No package on current line', vim.log.levels.WARN)
    return
  end

  -- Fetch all available versions and show picker
  local registry = require('local_plugins.pkg-version.registry')
  local picker = require('local_plugins.pkg-version.ui.picker')

  registry.fetch_all_versions(dep.name, bufnr, function(info, err)
    if err then
      vim.notify('Failed to fetch versions: ' .. err, vim.log.levels.ERROR)
      return
    end

    picker.select_version(dep.name, info, dep.version, function(version)
      if not version then
        return
      end

      local ops = require('local_plugins.pkg-version.operations')
      ops.change_version(dep.name, version, bufnr, function(success, error_msg)
        if not success then
          vim.notify('Change version failed: ' .. (error_msg or 'Unknown error'), vim.log.levels.ERROR)
        end
      end)
    end)
  end)
end

---Show package manager info
function M.show_package_manager_info()
  local bufnr = vim.api.nvim_get_current_buf()
  local pm = require('local_plugins.pkg-version.package_manager')

  local manager = pm.get_package_manager(bufnr)
  vim.notify('Package manager: ' .. manager, vim.log.levels.INFO, { title = 'pkg-version.nvim' })
end

---Get current package manager
---@return string
function M.get_package_manager()
  local pm = require('local_plugins.pkg-version.package_manager')
  return pm.get_package_manager()
end

return M
