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

return M
