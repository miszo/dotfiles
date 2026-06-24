local M = {}

M._installed = nil ---@type table<string,boolean>?
M._queries = {} ---@type table<string,boolean>

---@param update boolean?
function M.get_installed(update)
  if update or M._installed == nil then
    M._installed, M._queries = {}, {}
    local parser_dir = vim.fn.stdpath('data') .. '/site/parser'
    local patterns = {
      parser_dir .. '/*.so',
      parser_dir .. '/*.dylib',
      parser_dir .. '/*.dll',
    }

    for _, pattern in ipairs(patterns) do
      for _, path in ipairs(vim.fn.glob(pattern, false, true)) do
        local lang = vim.fn.fnamemodify(path, ':t:r')
        if lang ~= '' then
          M._installed[lang] = true
        end
      end
    end

    for _, lang in ipairs({ 'c', 'lua', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }) do
      if pcall(vim.treesitter.language.add, lang) then
        M._installed[lang] = true
      end
    end
  end
  return M._installed or {}
end

---@param lang string
---@param query string
function M.have_query(lang, query)
  local key = lang .. ':' .. query
  if M._queries[key] == nil then
    M._queries[key] = vim.treesitter.query.get(lang, query) ~= nil
  end
  return M._queries[key]
end

---@param what string|number|nil
---@param query? string
---@overload fun(buf?:number):boolean
---@overload fun(ft:string):boolean
---@return boolean
function M.have(what, query)
  what = what or vim.api.nvim_get_current_buf()
  what = type(what) == 'number' and vim.bo[what].filetype or what --[[@as string]]
  local lang = vim.treesitter.language.get_lang(what)
  if lang == nil then
    return false
  end
  if M.get_installed()[lang] == nil and not pcall(vim.treesitter.language.add, lang) then
    return false
  end
  M._installed[lang] = true
  if query and not M.have_query(lang, query) then
    return false
  end
  return true
end

function M.foldexpr()
  return M.have(nil, 'folds') and vim.treesitter.foldexpr() or '0'
end

return M
