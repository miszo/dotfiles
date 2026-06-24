local M = {}

---@class UserUtil.TreesitterTextobjectMoveOpts
---@field capture string
---@field query_group string?
---@field direction 1|-1
---@field edge 'start'|'end'

---@param range integer[]
---@param edge 'start'|'end'
local function position(range, edge)
  if edge == 'start' then
    return range[1], range[2]
  end
  return range[3], math.max(range[4] - 1, 0)
end

---@param a_row integer
---@param a_col integer
---@param b_row integer
---@param b_col integer
local function before(a_row, a_col, b_row, b_col)
  return a_row < b_row or (a_row == b_row and a_col < b_col)
end

---@param opts UserUtil.TreesitterTextobjectMoveOpts
function M.move_textobject(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  if not lang then
    return
  end

  local ok_parser, parser = pcall(vim.treesitter.get_parser, bufnr, lang, { error = false })
  if not ok_parser or not parser then
    return
  end

  local query = vim.treesitter.query.get(lang, opts.query_group or 'textobjects')
  if not query then
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row, cursor_col = cursor[1] - 1, cursor[2]
  local best ---@type {row: integer, col: integer}?

  parser:parse()
  for _, tree in ipairs(parser:trees()) do
    local root = tree:root()
    for id, node in query:iter_captures(root, bufnr, 0, -1) do
      if query.captures[id] == opts.capture:sub(2) then
        local row, col = position({ node:range() }, opts.edge)
        local is_candidate = opts.direction == 1 and before(cursor_row, cursor_col, row, col)
          or opts.direction == -1 and before(row, col, cursor_row, cursor_col)
        local is_better = not best
          or opts.direction == 1 and before(row, col, best.row, best.col)
          or opts.direction == -1 and before(best.row, best.col, row, col)
        if is_candidate and is_better then
          best = { row = row, col = col }
        end
      end
    end
  end

  if best then
    vim.api.nvim_win_set_cursor(0, { best.row + 1, best.col })
  end
end

return M
