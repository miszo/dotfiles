local M = {}

---Get project root for running package manager commands
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

---Execute package manager command with progress
---@param cmd string[] Command to execute
---@param cwd string Working directory
---@param progress_title string Progress title
---@param progress_msg string Progress message
---@param callback function(boolean, string?) Callback with success and error
local function execute_with_progress(cmd, cwd, progress_title, progress_msg, callback)
  local progress = require('local_plugins.pkg-version.ui.progress')
  local token = progress.start(progress_title, progress_msg)

  vim.system(cmd, {
    cwd = cwd,
    text = true,
  }, function(result)
    vim.schedule(function()
      if result.code == 0 then
        progress.done(token, 'Done: ' .. progress_msg)
        callback(true, nil)
      else
        local error_msg = result.stderr or result.stdout or 'Unknown error'
        progress.cancel(token, 'Failed: ' .. error_msg)
        callback(false, error_msg)
      end
    end)
  end)
end

---Install a package
---@param package_name string Package name (with optional @version)
---@param opts table? Options: { dev = boolean, peer = boolean, bufnr = number }
---@param callback function(boolean, string?) Callback with success and error
function M.install(package_name, opts, callback)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  
  local pm = require('local_plugins.pkg-version.package_manager')
  local config = require('local_plugins.pkg-version.config')
  
  local manager = pm.get_package_manager(bufnr)
  local project_root = get_project_root(bufnr)
  
  if not project_root then
    callback(false, 'Could not find package.json')
    return
  end

  local confirm_msg = string.format('Install %s using %s?', package_name, manager)
  
  if config.options.confirm_actions then
    vim.ui.select({'Yes', 'No'}, {
      prompt = confirm_msg,
    }, function(choice)
      if choice ~= 'Yes' then
        callback(false, 'Cancelled')
        return
      end

      local cmd = pm.get_install_command(manager, package_name, opts)
      local progress_msg = string.format('%s (%s)', package_name, manager)
      
      execute_with_progress(
        cmd,
        project_root,
        'Installing',
        progress_msg,
        function(success, err)
          if success then
            -- Reload the buffer to show updated package.json
            vim.defer_fn(function()
              vim.cmd('checktime')
              
              -- Invalidate cache and refresh
              local cache = require('local_plugins.pkg-version.cache')
              cache.invalidate(package_name:match('^([^@]+)'))
              
              local registry = require('local_plugins.pkg-version.registry')
              registry.clear_cache()
              
              local vtext = require('local_plugins.pkg-version.ui.virtual_text')
              vtext.refresh(bufnr)
            end, 500) -- Wait a bit for file system to update
          end
          callback(success, err)
        end
      )
    end)
  else
    local cmd = pm.get_install_command(manager, package_name, opts)
    local progress_msg = string.format('%s (%s)', package_name, manager)
    
    execute_with_progress(
      cmd,
      project_root,
      'Installing',
      progress_msg,
      callback
    )
  end
end

---Update a package
---@param package_name string Package name
---@param bufnr number? Buffer number
---@param callback function(boolean, string?) Callback with success and error
function M.update(package_name, bufnr, callback)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  
  local pm = require('local_plugins.pkg-version.package_manager')
  local config = require('local_plugins.pkg-version.config')
  
  local manager = pm.get_package_manager(bufnr)
  local project_root = get_project_root(bufnr)
  
  if not project_root then
    callback(false, 'Could not find package.json')
    return
  end

  local confirm_msg = string.format('Update %s using %s?', package_name, manager)
  
  if config.options.confirm_actions then
    vim.ui.select({'Yes', 'No'}, {
      prompt = confirm_msg,
    }, function(choice)
      if choice ~= 'Yes' then
        callback(false, 'Cancelled')
        return
      end

      local cmd = pm.get_update_command(manager, package_name, true) -- true = update to latest
      local progress_msg = string.format('%s to latest (%s)', package_name, manager)
      
      execute_with_progress(
        cmd,
        project_root,
        'Updating',
        progress_msg,
        function(success, err)
          if success then
            -- Reload the buffer to show updated package.json
            vim.defer_fn(function()
              vim.cmd('checktime')
              
              local cache = require('local_plugins.pkg-version.cache')
              cache.invalidate(package_name)
              
              local registry = require('local_plugins.pkg-version.registry')
              registry.clear_cache()
              
              local vtext = require('local_plugins.pkg-version.ui.virtual_text')
              vtext.refresh(bufnr)
            end, 500)
          end
          callback(success, err)
        end
      )
    end)
  else
    local cmd = pm.get_update_command(manager, package_name, true) -- true = update to latest
    local progress_msg = string.format('%s to latest (%s)', package_name, manager)
    
    execute_with_progress(
      cmd,
      project_root,
      'Updating',
      progress_msg,
      callback
    )
  end
end

---Delete a package
---@param package_name string Package name
---@param bufnr number? Buffer number
---@param callback function(boolean, string?) Callback with success and error
function M.delete(package_name, bufnr, callback)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  
  local pm = require('local_plugins.pkg-version.package_manager')
  local config = require('local_plugins.pkg-version.config')
  
  local manager = pm.get_package_manager(bufnr)
  local project_root = get_project_root(bufnr)
  
  if not project_root then
    callback(false, 'Could not find package.json')
    return
  end

  local confirm_msg = string.format('Delete %s using %s?', package_name, manager)
  
  if config.options.confirm_actions then
    vim.ui.select({'Yes', 'No'}, {
      prompt = confirm_msg,
    }, function(choice)
      if choice ~= 'Yes' then
        callback(false, 'Cancelled')
        return
      end

      local cmd = pm.get_delete_command(manager, package_name)
      local progress_msg = string.format('%s (%s)', package_name, manager)
      
      execute_with_progress(
        cmd,
        project_root,
        'Deleting',
        progress_msg,
        function(success, err)
          if success then
            -- Reload the buffer to show updated package.json
            vim.defer_fn(function()
              vim.cmd('checktime')
              
              local cache = require('local_plugins.pkg-version.cache')
              cache.invalidate(package_name)
              
              local registry = require('local_plugins.pkg-version.registry')
              registry.clear_cache()
              
              local vtext = require('local_plugins.pkg-version.ui.virtual_text')
              vtext.refresh(bufnr)
            end, 500)
          end
          callback(success, err)
        end
      )
    end)
  else
    local cmd = pm.get_delete_command(manager, package_name)
    local progress_msg = string.format('%s (%s)', package_name, manager)
    
    execute_with_progress(
      cmd,
      project_root,
      'Deleting',
      progress_msg,
      callback
    )
  end
end

---Change package version
---@param package_name string Package name
---@param version string New version
---@param bufnr number? Buffer number
---@param callback function(boolean, string?) Callback with success and error
function M.change_version(package_name, version, bufnr, callback)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  
  local package_with_version = package_name .. '@' .. version
  
  -- Use install command with the specific version
  M.install(package_with_version, { bufnr = bufnr }, callback)
end

return M
