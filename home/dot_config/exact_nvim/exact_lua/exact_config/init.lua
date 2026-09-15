local M = {}

M.icons = {
  misc = {
    dots = '󰇘',
  },
  dap = {
    Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
    Breakpoint = ' ',
    BreakpointCondition = ' ',
    BreakpointRejected = { ' ', 'DiagnosticError' },
    LogPoint = '.>',
  },
  diagnostics = {
    Error = ' ',
    Warn = ' ',
    Hint = ' ',
    Info = ' ',
  },
  git = {
    added = ' ',
    modified = ' ',
    removed = ' ',
  },
  kinds = {
    Array = ' ',
    Boolean = '󰨙 ',
    Class = ' ',
    Codeium = '󰘦 ',
    Color = ' ',
    Control = ' ',
    Collapsed = ' ',
    Constant = '󰏿 ',
    Constructor = ' ',
    Copilot = ' ',
    Emoji = '󰞅 ',
    Enum = ' ',
    EnumMember = ' ',
    Event = ' ',
    Field = ' ',
    File = ' ',
    Folder = ' ',
    Function = '󰊕 ',
    Interface = ' ',
    Key = ' ',
    Keyword = ' ',
    Laravel = ' ',
    LazyDev = '󰒲 ',
    Method = '󰊕 ',
    Module = ' ',
    Namespace = '󰦮 ',
    Null = ' ',
    Number = '󰎠 ',
    Object = ' ',
    Operator = ' ',
    Package = ' ',
    Property = ' ',
    Reference = ' ',
    Snippet = ' ',
    String = ' ',
    Struct = '󰆼 ',
    Text = ' ',
    TypeParameter = ' ',
    Unit = ' ',
    Value = ' ',
    Variable = '󰀫 ',
  },
  statusline = {
    debugger = ' ',
    ai_sidekick = '󰚩 ',
    copilot = ' ',
    copilot_stopped = ' ',
    copilot_warning = ' ',
  },
  package = {
    installing = '󰏗 ',
    updating = '󰚰 ',
    deleting = '󰆴 ',
    fetching = '󰄉 ',
    success = '󰄬 ',
    error = '󰅙 ',
  },
  ai_sidekick = {
    attached = ' ',
    started = ' ',
    installed = ' ',
    missing = ' ',
    external_attached = '󰖩 ',
    external_started = '󰖪 ',
    terminal_attached = ' ',
    terminal_started = ' ',
  },
  file = {
    modified = ' ',
    readonly = ' ',
  },
}

---@type table<string, string[]|boolean>?
M.kind_filter = {
  default = {
    'Class',
    'Constructor',
    'Enum',
    'Field',
    'Function',
    'Interface',
    'Method',
    'Module',
    'Namespace',
    'Package',
    'Property',
    'Struct',
    'Trait',
    'Variable',
  },
  markdown = false,
  help = false,
  -- you can specify a different filter for each filetype
  lua = {
    'Class',
    'Constructor',
    'Enum',
    'Field',
    'Function',
    'Interface',
    'Method',
    'Module',
    'Namespace',
    -- "Package", -- remove package since luals uses it for control flow structures
    'Property',
    'Struct',
    'Trait',
    'Variable',
  },
}

M.filetypes_to_skip_cursorline = {
  'lazy',
  'snacks_picker_input',
  'snacks_picker_results',
  'snacks_dashboard',
}

M.filetypes_to_close_with_q = {
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

M.filetypes_excluded_from_line_numbering =
  vim.list_extend(M.filetypes_to_close_with_q, filetypes_to_skip_line_numbering)

M.filetypes_excluded_from_smartcolumn = M.filetypes_excluded_from_line_numbering

M.buftypes_excluded_from_line_numbering = {
  'nofile',
  'terminal',
}

_G.UserConfig = M

return M
