local filetypes_excluded_from_cursorline = {
  'lazy',
  'snacks_picker_input',
  'snacks_picker_results',
  'snacks_dashboard',
}

local filetypes_to_close_with_q = {
  'PlenaryTestPopup',
  'codecompanion',
  'checkhealth',
  'dbout',
  'git',
  'gitsigns-blame',
  'grug-far',
  'help',
  'lspinfo',
  'neotest-output',
  'neotest-output-panel',
  'neotest-summary',
  'notify',
  'qf',
  'startuptime',
  'tsplayground',
  'snacks_dashboard',
}

local filetypes_to_skip_line_numbering = {
  'lazy',
  'mason',
  'snacks_picker_input',
  'snacks_picker_results',
}

local filetypes_excluded_from_line_numbering =
  vim.list_extend(filetypes_to_close_with_q, filetypes_to_skip_line_numbering)

local filetypes_to_skip_smartcolumn = {
  'markdown',
  'mdx',
}

local buftypes_excluded_from_line_numbering = {
  'nofile',
  'terminal',
}

local M = {
  filetypes = {
    to_close_with_q = filetypes_to_close_with_q,
    excluded_from_cursorline = filetypes_excluded_from_cursorline,
    excluded_from_line_numbering = filetypes_excluded_from_line_numbering,
    excluded_from_smartcolumn = vim.list_extend(filetypes_excluded_from_line_numbering, filetypes_to_skip_smartcolumn),
  },
  buftypes = {
    excluded_from_line_numbering = buftypes_excluded_from_line_numbering,
  },
}

return M
