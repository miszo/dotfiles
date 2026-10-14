local M = {}

vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
  group = vim.api.nvim_create_augroup('miszo/statusline', { clear = true }),
  callback = vim.schedule_wrap(function()
    if package.loaded['lualine'] then
      require('lualine').refresh({ place = { 'statusline' } })
    end
  end),
})

function M.macro_recording()
  local register = vim.fn.reg_recording()
  return register ~= '' and ('recording @%s'):format(register) or ''
end

function M.is_recording_macro()
  return M.macro_recording() ~= ''
end

--- Format text with a highlight group for use in lualine components.
--- Adapted from LazyVim's lualine.format.
---@param component any lualine component instance
---@param text string
---@param hl_group? string
---@return string
local function format(component, text, hl_group)
  text = text:gsub('%%', '%%%%')
  if not hl_group or hl_group == '' then
    return text
  end

  ---@type table<string, string>
  component.hl_cache = component.hl_cache or {}
  local lualine_hl_group = component.hl_cache[hl_group]
  if not lualine_hl_group then
    local utils = require('lualine.utils.utils')
    ---@type string[]
    local gui = vim.tbl_filter(function(x)
      return x
    end, {
      utils.extract_highlight_colors(hl_group, 'bold') and 'bold',
      utils.extract_highlight_colors(hl_group, 'italic') and 'italic',
    })

    lualine_hl_group = component:create_hl({
      fg = utils.extract_highlight_colors(hl_group, 'fg'),
      gui = #gui > 0 and table.concat(gui, ',') or nil,
    }, 'PP_' .. hl_group) --[[@as string]]
    component.hl_cache[hl_group] = lualine_hl_group
  end
  return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
end

--- Return a lualine component function that renders the file path
--- with smart truncation and separate directory/filename highlighting.
--- Adapted from LazyVim's lualine.pretty_path.
---@param opts? { relative: "cwd"|"root", modified_hl: string?, directory_hl: string?, filename_hl: string?, modified_sign: string?, readonly_icon: string?, length: number? }
---@return fun(self: any): string
function M.pretty_path(opts)
  opts = vim.tbl_extend('force', {
    relative = 'cwd',
    modified_hl = 'MatchParen',
    directory_hl = '',
    filename_hl = 'Bold',
    modified_sign = ' ' .. UserConfig.icons.file.modified:gsub('%s+$', ''),
    readonly_icon = ' ' .. UserConfig.icons.file.readonly:gsub('%s+$', ''),
    length = 4,
  }, opts or {})

  return function(self)
    local path = vim.fn.expand('%:p') --[[@as string]]
    if path == '' then
      return ''
    end

    local cwd = UserUtil.root.cwd()
    local project_root = UserUtil.root.get({ normalize = true })

    if opts.relative == 'cwd' and cwd ~= '' and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    elseif project_root ~= '' and path:find(project_root, 1, true) == 1 then
      path = path:sub(#project_root + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, '[\\/]')

    if opts.length == 0 then
      -- show full path
      parts = parts
    elseif #parts > opts.length then
      parts = { parts[1], '…', unpack(parts, #parts - opts.length + 2, #parts) }
    end

    -- Highlight filename (last part)
    if opts.modified_hl and vim.bo.modified then
      parts[#parts] = parts[#parts] .. opts.modified_sign
      parts[#parts] = format(self, parts[#parts], opts.modified_hl)
    else
      parts[#parts] = format(self, parts[#parts], opts.filename_hl)
    end

    -- Highlight directory part
    local dir = ''
    if #parts > 1 then
      dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep)
      dir = format(self, dir .. sep, opts.directory_hl)
    end

    -- Readonly indicator
    local readonly = ''
    if vim.bo.readonly then
      readonly = format(self, opts.readonly_icon, opts.modified_hl)
    end

    return dir .. parts[#parts] .. readonly
  end
end

return M
