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
  ts = '',
  yarn = '',
  node = '󰎙',
  tool = '󰒓',
  tsconfig = '',
  angular = '󰚲',
  react = '',
}

local hl = {
  js = 'MiniIconsYellow',
  jsx = 'MiniIconsOrange',
  ts = 'MiniIconsAzure',
  tsx = 'MiniIconsBlue',
  ignore = 'MiniIconsPurple',
  eslint = 'MiniIconsBlue',
  prettier = 'MiniIconsOrange',
  node = 'MiniIconsGreen',
  npm = 'MiniIconsRed',
  yarn = 'MiniIconsCyan',
  tailwind = 'MiniIconsAzure',
  config = 'MiniIconsGreen',
  webpack = 'MiniIconsBlue',
  angular = {
    main = 'MiniIconsRed',
    component = 'MiniIconsBlue',
    directive = 'MiniIconsPurple',
    service = 'MiniIconsOrange',
  },
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
      ['angular.json'] = { glyph = file_icons.angular, hl = hl.angular.main },
    },
    extension = {
      ['component.ts'] = { glyph = file_icons.angular, hl = hl.angular.component },
      ['directive.ts'] = { glyph = file_icons.angular, hl = hl.angular.directive },
      ['module.ts'] = { glyph = file_icons.angular, hl = hl.angular.main },
      ['service.ts'] = { glyph = file_icons.angular, hl = hl.angular.service },
    },
  }
end

M.get_icons = function()
  local test_js_table = { glyph = file_icons.test, hl = hl.js }
  local jsx_table = { glyph = file_icons.react, hl = hl.jsx }
  local test_jsx_table = { glyph = file_icons.test, hl = hl.jsx }
  local test_ts_table = { glyph = file_icons.test, hl = hl.ts }
  local test_tsx_table = { glyph = file_icons.test, hl = hl.tsx }
  local eslint_table = { glyph = file_icons.eslint, hl = hl.eslint }
  local prettier_table = { glyph = file_icons.prettier, hl = hl.prettier }
  local tailwind_table = { glyph = file_icons.tailwind, hl = hl.tailwind }
  local npm_table = { glyph = file_icons.npm, hl = hl.npm }
  local node_table = { glyph = file_icons.node, hl = hl.node }
  local yarn_table = { glyph = file_icons.yarn, hl = hl.yarn }

  local icons = {
    file = {
      ['.nvmrc'] = node_table,
      ['.node-version'] = node_table,
      ['.tool-versions'] = { glyph = file_icons.tool, hl = hl.config },
      ['.eslintrc'] = eslint_table,
      ['.eslintrc.json'] = eslint_table,
      ['.eslintrc.js'] = eslint_table,
      ['.eslintrc.cjs'] = eslint_table,
      ['.eslintrc.mjs'] = eslint_table,
      ['.eslintignore'] = { glyph = file_icons.eslint, hl = hl.ignore },
      ['eslint.config.json'] = eslint_table,
      ['eslint.config.js'] = eslint_table,
      ['eslint.config.cjs'] = eslint_table,
      ['eslint.config.mjs'] = eslint_table,
      ['.prettierignore'] = { glyph = file_icons.prettier, hl = hl.ignore },
      ['.prettierrc'] = prettier_table,
      ['.prettierrc.json'] = prettier_table,
      ['.prettierrc.js'] = prettier_table,
      ['.prettierrc.cjs'] = prettier_table,
      ['.prettierrc.mjs'] = prettier_table,
      ['prettier.config.js'] = prettier_table,
      ['prettier.config.cjs'] = prettier_table,
      ['prettier.config.mjs'] = prettier_table,
      ['tailwind.config.js'] = tailwind_table,
      ['tailwind.config.cjs'] = tailwind_table,
      ['tailwind.config.mjs'] = tailwind_table,
      ['tsconfig.json'] = { glyph = file_icons.tsconfig, hl = hl.ts },
      ['.npmrc'] = npm_table,
      ['.npmignore'] = { glyph = file_icons.npm, hl = hl.ignore },
      ['package.json'] = npm_table,
      ['package-lock.json'] = npm_table,
      ['yarn.lock'] = yarn_table,
      ['.yarnrc'] = yarn_table,
      ['.yarnrc.yml'] = yarn_table,
      ['.yarnrc.yaml'] = yarn_table,
    },
    filetype = {
      javascriptreact = jsx_table,
    },
    extension = {
      ['test.js'] = test_js_table,
      ['test.jsx'] = test_jsx_table,
      ['test.ts'] = test_ts_table,
      ['test.tsx'] = test_tsx_table,
      ['spec.js'] = test_js_table,
      ['spec.jsx'] = test_jsx_table,
      ['spec.ts'] = test_ts_table,
      ['spec.tsx'] = test_tsx_table,
      ['cy.js'] = test_js_table,
      ['cy.jsx'] = test_jsx_table,
      ['cy.ts'] = test_ts_table,
      ['cy.tsx'] = test_tsx_table,
    },
  }

  local angular_icons = get_angular_icons()
  icons.file = vim.tbl_deep_extend('force', icons.file, angular_icons.file)
  icons.extension = vim.tbl_deep_extend('force', icons.extension, angular_icons.extension)

  return icons
end

return M
