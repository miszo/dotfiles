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
  opts = vim.tbl_deep_extend('force', {}, opts or {}, UserUtil.plugins.opts('conform.nvim').format or {})
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

---@param path string
---@param fields string|string[]
---@return boolean
local function package_json_has_field(path, fields)
  local ok, content = pcall(vim.fn.readblob, path)
  if not ok or not content then
    return false
  end

  local ok_decode, json = pcall(vim.json.decode, content)
  if not ok_decode or type(json) ~= 'table' then
    return false
  end

  fields = type(fields) == 'table' and fields or { fields }
  for _, field in ipairs(fields) do
    if json[field] ~= nil then
      return true
    end
  end

  return false
end

---@param config_files string[]
---@param field string|string[]
---@param fname string
---@return string[]
function M.insert_package_json(config_files, field, fname)
  local ret = vim.deepcopy(config_files)
  local root = vim.fs.dirname(fname)
  local package_json = vim.fs.find('package.json', { path = root, upward = true, type = 'file' })[1]

  if package_json and package_json_has_field(package_json, field) then
    table.insert(ret, 'package.json')
  end

  return ret
end

---@param root_markers string[]
---@param files string[]
---@param fields string|string[]
---@param fname string
---@param mode? 'all'|'any'
---@return string[]
function M.root_markers_with_field(root_markers, files, fields, fname, mode)
  local ret = vim.deepcopy(root_markers)
  local path = vim.fs.dirname(fname)
  fields = type(fields) == 'table' and fields or { fields }

  for _, file in ipairs(files) do
    local found = vim.fs.find(file, { path = path, upward = true, type = 'file' })[1]
    if found then
      local ok, lines = pcall(vim.fn.readfile, found)
      if ok then
        local content = table.concat(lines, '\n')
        local matched = 0
        for _, field in ipairs(fields) do
          if content:find(field) then
            matched = matched + 1
          end
        end

        if (mode == 'all' and matched == #fields) or (mode ~= 'all' and matched > 0) then
          table.insert(ret, file)
        end
      end
    end
  end

  return ret
end

---@param root_dir string?
---@return string?
function M.get_typescript_server_path(root_dir)
  local function check(path)
    return path and vim.uv.fs_stat(path) and path or nil
  end

  if root_dir then
    local local_tsdk = vim.fs.joinpath(root_dir, 'node_modules', 'typescript', 'lib')
    local local_tsdk_found = check(local_tsdk)
    if local_tsdk_found then
      return local_tsdk_found
    end
  end

  local mason_tsdk = vim.fs.joinpath(
    vim.fn.stdpath('data'),
    'mason',
    'packages',
    'typescript-language-server',
    'node_modules',
    'typescript',
    'lib'
  )
  local mason_tsdk_found = check(mason_tsdk)
  if mason_tsdk_found then
    return mason_tsdk_found
  end

  local vtsls_tsdk = vim.fs.joinpath(
    vim.fn.stdpath('data'),
    'mason',
    'packages',
    'vtsls',
    'node_modules',
    'typescript',
    'lib'
  )
  return check(vtsls_tsdk)
end

return M
