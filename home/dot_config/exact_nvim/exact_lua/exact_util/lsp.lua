local M = {}

---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: vim.lsp.Client):boolean}

---@param opts? lsp.Client.filter
function M.get_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]
  ret = vim.lsp.get_clients(opts)
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@alias lsp.Client.format {timeout_ms?: number, format_options?: table} | lsp.Client.filter

---@param opts? lsp.Client.format
function M.format(opts)
  opts = vim.tbl_deep_extend(
    'force',
    {},
    opts or {},
    UserUtil.plugins.opts('nvim-lspconfig').format or {},
    UserUtil.plugins.opts('conform.nvim').format or {}
  )
  local ok, conform = pcall(require, 'conform')
  -- use conform for formatting with LSP when available,
  -- since it has better format diffing
  if ok then
    opts.formatters = {}
    conform.format(opts)
  else
    vim.lsp.buf.format(opts)
  end
end

---@param opts? Formatter| {filter?: (string|lsp.Client.filter)}
function M.formatter(opts)
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == 'string' and { name = filter } or filter
  local ret = {
    name = 'LSP',
    primary = true,
    priority = 1,
    format = function(buf)
      M.format(UserUtil.lazyCoreUtil.merge({}, filter, { bufnr = buf }))
    end,
    sources = function(buf)
      local clients = M.get_clients(UserUtil.lazyCoreUtil.merge({}, filter, { bufnr = buf }))
      ---@param client vim.lsp.Client
      local ret = vim.tbl_filter(function(client)
        return client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting)
          or client:supports_method(vim.lsp.protocol.Methods.textDocument_rangeFormatting)
      end, clients)
      ---@param client vim.lsp.Client
      return vim.tbl_map(function(client)
        return client.name
      end, ret)
    end,
  }
  return UserUtil.lazyCoreUtil.merge(ret, opts)
end

return M
