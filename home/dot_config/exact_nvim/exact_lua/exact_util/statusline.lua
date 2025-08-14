local M = {}

function M.filename_fmt(str)
  return Snacks.picker.util.truncpath(str, 40)
end

function M.filename_color()
  if vim.bo.modified then
    return { fg = Snacks.util.color('Constant', 'fg') }
  end

  if vim.bo.readonly then
    return { fg = Snacks.util.color('Comment', 'fg') }
  end

  return { fg = Snacks.util.color('Normal', 'fg') }
end

function M.mcphub()
  return {
    function()
      -- Check if MCPHub is loaded
      if not vim.g.loaded_mcphub then
        return UserConfig.icons.statusline.mcphub_stopped .. '-'
      end

      local count = vim.g.mcphub_servers_count or 0
      local status = vim.g.mcphub_status or 'stopped'
      local executing = vim.g.mcphub_executing

      -- Show "-" when stopped
      if status == 'stopped' then
        return UserConfig.icons.statusline.mcphub_stopped .. '-'
      end

      if status == 'starting' or status == 'restarting' then
        return UserConfig.icons.statusline.mcphub_warning
      end

      -- Show spinner when executing, starting, or restarting
      if executing then
        local frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
        local frame = math.floor(vim.loop.now() / 100) % #frames + 1
        return UserConfig.icons.statusline.mcphub .. frames[frame]
      end

      return UserConfig.icons.statusline.mcphub .. count
    end,
    color = function()
      if not vim.g.loaded_mcphub then
        return { fg = Snacks.util.color('Comment', 'fg') } -- not loaded
      end

      local status = vim.g.mcphub_status or 'stopped'
      if status == 'ready' or status == 'restarted' then
        return { fg = Snacks.util.color('DiagnosticSignHint', 'fg') } -- connected
      elseif status == 'starting' or status == 'restarting' then
        return { fg = Snacks.util.color('DiagnosticSignWarn', 'fg') } -- connecting
      else
        return { fg = Snacks.util.color('DiagnosticSignError', 'fg') } -- error or stopped
      end
    end,
  }
end

return M
