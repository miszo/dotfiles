local M = {}

local function lsp_status_short()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients == 0 then
    return '' -- Return empty string when no LSP
  end

  local names = {}
  local icon = UserUtil.icons.get_statusline_icon('lsp')
  for _, client in ipairs(clients) do
    if client.name ~= 'copilot' then
      table.insert(names, client.name)
    end
  end

  return icon .. ' ' .. table.concat(names, ', ')
end

local function formatter_status()
  local ok, conform = pcall(require, 'conform')
  if not ok then
    return ''
  end

  local formatters = conform.list_formatters_to_run(0)
  if #formatters == 0 then
    return ''
  end

  local formatter_names = {}
  local icon = UserUtil.icons.get_statusline_icon('formatter')
  for _, formatter in ipairs(formatters) do
    table.insert(formatter_names, formatter.name)
  end

  return icon .. ' ' .. table.concat(formatter_names, ', ')
end

local function linter_status()
  local ok, lint = pcall(require, 'lint')
  if not ok then
    return ''
  end

  local linters = lint.linters_by_ft[vim.bo.filetype] or {}
  local icon = UserUtil.icons.get_statusline_icon('linter')
  if #linters == 0 then
    return ''
  end

  return icon .. ' ' .. table.concat(linters, ', ')
end

local function safe_lsp_status()
  local ok, result = pcall(lsp_status_short)
  return ok and result or ''
end

local function safe_formatter_status()
  local ok, result = pcall(formatter_status)
  return ok and result or ''
end

local function safe_linter_status()
  local ok, result = pcall(linter_status)
  return ok and result or ''
end

M.attached_clients = function()
  local lsp_clients = safe_lsp_status()
  local formatters = safe_formatter_status()
  local linters = safe_linter_status()

  local clients = vim.tbl_filter(function(client)
    return client ~= ''
  end, {
    lsp_clients,
    formatters,
    linters,
  })

  if #clients == 0 then
    return '' -- Return empty string when no clients
  end

  return table.concat(clients, ' ')
end

M.show_attached_clients = function()
  local clients = M.attached_clients()

  return #clients > 0
end

M.padding = {
  left = 2,
  right = 1,
}

return M
