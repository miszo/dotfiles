local M = {}

---@type table<number, string>
M.cache = {}

---@param path string?
---@return string?
local function realpath(path)
  if not path or path == '' then
    return nil
  end
  return vim.uv.fs_realpath(path)
end

---@param buf number
---@return string?
local function bufpath(buf)
  return realpath(vim.api.nvim_buf_get_name(buf))
end

--- Detect root via LSP workspace folders / root_dir
---@param buf number
---@return string[]
local function detect_lsp(buf)
  local bp = bufpath(buf)
  if not bp then
    return {}
  end
  local roots = {}
  for _, client in pairs(vim.lsp.get_clients({ bufnr = buf })) do
    local workspace = client.config.workspace_folders
    for _, ws in pairs(workspace or {}) do
      local p = realpath(vim.uri_to_fname(ws.uri))
      if p and bp:find(p, 1, true) == 1 then
        roots[#roots + 1] = p
      end
    end
    if client.root_dir then
      local p = realpath(client.root_dir)
      if p and bp:find(p, 1, true) == 1 then
        roots[#roots + 1] = p
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  return roots
end

--- Detect root via pattern matching (e.g. .git, Makefile, etc.)
---@param buf number
---@param patterns string[]
---@return string[]
local function detect_pattern(buf, patterns)
  local path = bufpath(buf) or vim.uv.cwd()
  local match = vim.fs.find(patterns, { path = path, upward = true })[1]
  if match then
    return { vim.fs.dirname(match) }
  end
  return {}
end

--- Get the project root for a given buffer.
--- Detection order: LSP -> .git pattern -> cwd
---@param opts? { buf?: number, normalize?: boolean }
---@return string
function M.get(opts)
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()

  local ret = M.cache[buf]
  if not ret then
    -- Try LSP first
    local roots = detect_lsp(buf)
    if #roots == 0 then
      -- Then try .git pattern
      roots = detect_pattern(buf, { '.git' })
    end
    ret = roots[1] or vim.uv.cwd()
    M.cache[buf] = ret
  end

  return ret
end

--- Find the nearest ancestor directory containing one of the given markers.
--- Returns the directory path or nil if no marker is found.
---@param buf number Buffer number (0 for current)
---@param markers string[] File/directory names to search for
---@return string?
function M.find(buf, markers)
  local roots = detect_pattern(buf, markers)
  return roots[1]
end

--- Get the current working directory (normalized)
---@return string
function M.cwd()
  return realpath(vim.uv.cwd()) or ''
end

function M.setup()
  vim.api.nvim_create_autocmd({ 'LspAttach', 'BufWritePost', 'DirChanged', 'BufEnter' }, {
    group = vim.api.nvim_create_augroup('user_root_cache', { clear = true }),
    callback = function(event)
      M.cache[event.buf] = nil
    end,
  })
end

return M
