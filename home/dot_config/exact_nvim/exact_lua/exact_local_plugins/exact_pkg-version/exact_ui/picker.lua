local M = {}

---Select a version using vim.ui.select
---@param package_name string Package name
---@param version_info table Version information with versions array
---@param current_version string? Current version for highlighting
---@param callback function(string|nil) Callback with selected version or nil
function M.select_version(package_name, version_info, current_version, callback)
  if not version_info or not version_info.versions or #version_info.versions == 0 then
    vim.notify('No versions available for ' .. package_name, vim.log.levels.WARN)
    callback(nil)
    return
  end

  -- Reverse to show latest first
  local versions = {}
  for i = #version_info.versions, 1, -1 do
    table.insert(versions, version_info.versions[i])
  end

  -- Format versions for display
  local formatted_items = {}
  local clean_current = current_version and current_version:gsub('^[~^>=<]+', '')
  
  for _, version in ipairs(versions) do
    local text = version
    
    -- Add latest indicator
    if version == version_info.latest then
      text = text .. ' (latest)'
    end
    
    -- Add current indicator
    if clean_current and version == clean_current then
      text = text .. ' [current]'
    end
    
    table.insert(formatted_items, text)
  end

  -- Use vim.ui.select
  vim.ui.select(formatted_items, {
    prompt = 'Select version for ' .. package_name .. ':',
    format_item = function(item)
      return item
    end,
  }, function(choice, idx)
    if choice and idx then
      callback(versions[idx])
    else
      callback(nil)
    end
  end)
end

---Select dependency type
---@param callback function(string|nil) Callback with type: 'dep', 'dev', 'peer' or nil
function M.select_dependency_type(callback)
  local options = {
    { text = 'dependencies', value = 'dep' },
    { text = 'devDependencies', value = 'dev' },
    { text = 'peerDependencies', value = 'peer' },
  }

  vim.ui.select(options, {
    prompt = 'Select dependency type:',
    format_item = function(item)
      return item.text
    end,
  }, function(choice, idx)
    if choice and idx then
      callback(options[idx].value)
    else
      callback(nil)
    end
  end)
end

return M
