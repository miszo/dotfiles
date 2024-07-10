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
    Info = ' ',
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
    TabNine = '󰏚 ',
    Text = ' ',
    TypeParameter = ' ',
    Unit = ' ',
    Value = ' ',
    Variable = '󰀫 ',
  },
}

local file_icons = {
  test = '',
  prettier = '',
  eslint = '',
  npm = '',
  tailwind = '󱏿',
  tsconfig = '',
  yarn = '',
  node = '',
  tool = '󰒓',
  astro = '',
  angular = '󰚲',
}

local get_angular_root = function()
  local root_patterns = { 'angular.json' }
  return vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
end

local get_angular_icons = function()
  local root = get_angular_root()
  if not root then
    return {
      file = {},
      extension = {},
    }
  end
  return {
    file = {
      ['angular.json'] = { glyph = file_icons.angular, hl = 'MiniIconsRed' },
    },
    extension = {
      ['component.ts'] = { glyph = file_icons.angular, hl = 'MiniIconsBlue' },
      ['directive.ts'] = { glyph = file_icons.angular, hl = 'MiniIconsPurple' },
      ['module.ts'] = { glyph = file_icons.angular, hl = 'MiniIconsRed' },
      ['service.ts'] = { glyph = file_icons.angular, hl = 'MiniIconsYellow' },
    },
  }
end

M.get_icons = function()
  local js_table = { glyph = file_icons.test, hl = 'MiniIconsYellow' }
  local jsx_table = { glyph = file_icons.test, hl = 'MiniIconsAzure' }
  local ts_table = { glyph = file_icons.test, hl = 'MiniIconsAzure' }
  local tsx_table = { glyph = file_icons.test, hl = 'MiniIconsBlue' }
  local eslint_table = { glyph = file_icons.eslint, hl = 'MiniIconsBlue' }
  local prettier_table = { glyph = file_icons.prettier, hl = 'MiniIconsOrange' }
  local tw_table = { glyph = file_icons.tailwind, hl = 'MiniIconsAzure' }
  local npm_table = { glyph = file_icons.npm, hl = 'MiniIconsRed' }
  local node_table = { glyph = file_icons.node, hl = 'MiniIconsGreen' }
  local yarn_table = { glyph = file_icons.yarn, hl = 'MiniIconsCyan' }

  local icons = {
    file = {
      ['.nvmrc'] = node_table,
      ['.node-version'] = node_table,
      ['.tool-versions'] = { glyph = file_icons.tool, hl = 'MiniIconsGrey' },
      ['.eslintrc'] = eslint_table,
      ['.eslintrc.json'] = eslint_table,
      ['.eslintrc.js'] = eslint_table,
      ['.eslintrc.cjs'] = eslint_table,
      ['.eslintrc.mjs'] = eslint_table,
      ['.eslintignore'] = { glyph = file_icons.eslint, hl = 'MiniIconsPurple' },
      ['eslint.config.js'] = eslint_table,
      ['eslint.config.cjs'] = eslint_table,
      ['eslint.config.mjs'] = eslint_table,
      ['.prettierignore'] = { glyph = file_icons.prettier, hl = 'MiniIconsPurple' },
      ['.prettierrc'] = prettier_table,
      ['.prettierrc.json'] = prettier_table,
      ['.prettierrc.js'] = prettier_table,
      ['.prettierrc.cjs'] = prettier_table,
      ['.prettierrc.mjs'] = prettier_table,
      ['prettier.config.js'] = prettier_table,
      ['prettier.config.cjs'] = prettier_table,
      ['prettier.config.mjs'] = prettier_table,
      ['tailwind.config.js'] = tw_table,
      ['tailwind.config.cjs'] = tw_table,
      ['tailwind.config.mjs'] = tw_table,
      ['tsconfig.json'] = { glyph = file_icons.tsconfig, hl = 'MiniIconsAzure' },
      ['.npmrc'] = npm_table,
      ['.npmignore'] = npm_table,
      ['package.json'] = npm_table,
      ['package-lock.json'] = npm_table,
      ['yarn.lock'] = yarn_table,
      ['.yarnrc'] = yarn_table,
      ['.yarnrc.yml'] = yarn_table,
      ['.yarnrc.yaml'] = yarn_table,
    },
    extension = {
      ['test.js'] = js_table,
      ['test.jsx'] = jsx_table,
      ['test.ts'] = ts_table,
      ['test.tsx'] = tsx_table,
      ['spec.js'] = js_table,
      ['spec.jsx'] = jsx_table,
      ['spec.ts'] = ts_table,
      ['spec.tsx'] = tsx_table,
      ['cy.js'] = js_table,
      ['cy.jsx'] = jsx_table,
      ['cy.ts'] = ts_table,
      ['cy.tsx'] = tsx_table,
      ['astro'] = { glyph = file_icons.astro, hl = 'MiniIconsOrange' },
    },
  }

  local angular_icons = get_angular_icons()
  icons.file = vim.tbl_deep_extend('force', icons.file, angular_icons.file)
  icons.extension = vim.tbl_deep_extend('force', icons.extension, angular_icons.extension)

  return icons
end

return M
