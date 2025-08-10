local M = {}
---@class Formatter
---@field name string
---@field primary? boolean
---@field format fun(bufnr:number)
---@field sources fun(bufnr:number):string[]
---@field priority number

M.formatters = {} ---@type Formatter[]

---@param formatter Formatter
function M.register(formatter)
  M.formatters[#M.formatters + 1] = formatter
  table.sort(M.formatters, function(a, b)
    return a.priority > b.priority
  end)
end

function M.formatexpr()
  if UserUtil.plugins.has('conform.nvim') then
    return require('conform').formatexpr()
  end
  return vim.lsp.formatexpr({ timeout_ms = 3000 })
end

---@param buf? number
---@return (Formatter|{active:boolean,resolved:string[]})[]
function M.resolve(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local have_primary = false
  ---@param formatter Formatter
  return vim.tbl_map(function(formatter)
    local sources = formatter.sources(buf)
    local active = #sources > 0 and (not formatter.primary or not have_primary)
    have_primary = have_primary or (active and formatter.primary) or false
    return setmetatable({
      active = active,
      resolved = sources,
    }, { __index = formatter })
  end, M.formatters)
end

---@param buf? number
function M.info(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local lines = {
    '# Status',
  }
  local have = false
  for _, formatter in ipairs(M.resolve(buf)) do
    if #formatter.resolved > 0 then
      have = true
      lines[#lines + 1] = '\n# ' .. formatter.name .. (formatter.active and ' ***(active)***' or '')
      for _, line in ipairs(formatter.resolved) do
        lines[#lines + 1] = ('- [%s] **%s**'):format(formatter.active and 'x' or ' ', line)
      end
    end
  end
  if not have then
    lines[#lines + 1] = '\n***No formatters available for this buffer.***'
  end
  UserUtil.lazyCoreUtil.info(table.concat(lines, '\n'), { title = 'Format' })
end

---@param opts? {force?:boolean, buf?:number}
function M.format(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  local done = false
  for _, formatter in ipairs(M.resolve(buf)) do
    if formatter.active then
      done = true
      UserUtil.lazyCoreUtil.try(function()
        return formatter.format(buf)
      end, { msg = 'Formatter `' .. formatter.name .. '` failed' })
    end
  end

  if not done and opts and opts.force then
    UserUtil.lazyCoreUtil.warn('No formatter available', { title = 'LazyVim' })
  end
end

return M
