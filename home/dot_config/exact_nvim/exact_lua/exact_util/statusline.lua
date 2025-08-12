local M = {}

function M.filename_fmt(str)
  return Snacks.picker.util.truncpath(str, 40)
end

function M.filename_color()
  local color = require('catppuccin.palettes').get_palette()
  if vim.bo.modified then
    return { fg = color.peach }
  end

  if vim.bo.readonly then
    return { fg = color.overlay2 }
  end

  return { fg = color.text }
end

local function get_copilot_status()
  local status = require('copilot.status').data.status
  if status == 'InProgress' then
    return 'pending'
  elseif status == 'Warning' then
    return 'error'
  else
    return 'ok'
  end
end

local function get_copilot_color()
  local color = require('catppuccin.palettes').get_palette()
  local colors = {
    ok = color.lavender,
    error = color.red,
    pending = color.peach,
  }

  local status = get_copilot_status()

  return {
    fg = colors[status],
  }
end

local function has_copilot()
  local clients = package.loaded['copilot'] and vim.lsp.get_clients({ bufnr = 0, name = 'copilot' })
  return #clients > 0
end

function M.copilot()
  return {
    function()
      return UserConfig.icons.kinds.Copilot
    end,
    cond = has_copilot,
    color = get_copilot_color,
  }
end

return M
