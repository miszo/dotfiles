local icons = require('utils.icons').icons

local get_root_dir = function(...)
  local util = require('lspconfig.util')
  return util.root_pattern('package.json', 'tsconfig.json')(...) or util.root_pattern('.git')(...)
end

local diagnostic_signs = {
  [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
  [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
  [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
  [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
}

local shorter_source_names = {
  ['Lua Diagnostics.'] = 'Lua',
  ['Lua Syntax Check.'] = 'Lua',
}

local function diagnostic_format(diagnostic)
  if not diagnostic.source or not diagnostic.code then
    return string.format('%s %s', diagnostic_signs[diagnostic.severity], diagnostic.message)
  end
  return string.format(
    '%s %s (%s): %s',
    diagnostic_signs[diagnostic.severity],
    shorter_source_names[diagnostic.source] or diagnostic.source,
    diagnostic.code,
    diagnostic.message
  )
end

local ts_preferences = {
  importModuleSpecifier = 'non-relative',
  preferTypeOnlyAutoImports = true,
  quoteStyle = 'single',
  useAliasesForRenames = false,
}

--- Set 8GB for tsserver memory limit
local max_ts_server_memory = 8192

---@module "lazy"
---@type LazySpec[]
return {
  -- tools
  {
    'mason-org/mason.nvim',
    opts = function(_, opts)
      vim.tbl_deep_extend('force', {}, opts.ensure_installed, {
        'angular-language-server',
        'css-lsp',
        'luacheck',
        'selene',
        'shfmt',
        'stylua',
        'tailwindcss-language-server',
        'vue',
        'vtsls',
      })
    end,
  },
  -- lsp servers
  {
    'neovim/nvim-lspconfig',
    opts = {
      diagnostics = {
        virtual_text = {
          spacing = 4,
          prefix = '',
          format = diagnostic_format,
          severity = {
            max = vim.diagnostic.severity.WARN,
          },
        },
        virtual_lines = {
          format = diagnostic_format,
          severity = {
            min = vim.diagnostic.severity.ERROR,
          },
        },
        underline = true,
        severity_sort = true,
      },
      inlay_hints = { enabled = false },
      servers = {
        cssls = {},
        sourcekit = {},
        ruby_lsp = {
          mason = false,
          cmd = { vim.fn.expand('~/.asdf/shims/ruby-lsp') },
          init_options = {
            bundleGemfile = vim.fn.expand('~/.ruby-lsp/Gemfile'),
            enabledFeatures = {
              'codeActions',
              'completion',
              'definition',
              'diagnostics',
              'documentHighlights',
              'documentLink',
              'documentSymbols',
              'foldingRanges',
              'formatting',
              'hover',
              'selectionRanges',
              'semanticHighlighting',
              'signatureHelp',
              'typeHierarchy',
              'workspaceSymbol',
            },
            experimentalFeaturesEnabled = false,
            formatter = 'auto',
            indexing = {
              excludedPatterns = {
                '**/test/**/*',
                '**/spec/**/*',
                '**/db/**/*',
                '**/vendor/**/*',
                '**/.git',
                '**/.svn',
                '**/.hg',
                '**/CVS',
                '**/.DS_Store',
                '**/tmp/**/*',
                '**/node_modules/**/*',
                '**/bower_components/**/*',
                '**/dist/**/*',
                '**/.git/objects/**',
                '**/.git/subtree-cache/**',
              },
            },
          },
        },
        eslint = {
          root_dir = get_root_dir,
          settings = {
            codeActionOnSave = {
              enable = true,
              mode = 'all',
            },
          },
        },
        vtsls = {
          root_dir = get_root_dir,
          settings = {
            typescript = {
              preferences = ts_preferences,
              tsserver = {
                maxTsServerMemory = max_ts_server_memory,
              },
            },
            javascript = {
              preferences = ts_preferences,
            },
            vtsls = {
              autoUseWorkspaceTsdk = true,
              enableMoveToFileCodeAction = true,
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        lua_ls = {
          single_file_support = true,
          Lua = {
            type = {
              castNumberToInteger = true,
            },
            diagnostics = {
              disable = { 'incomplete-signature-doc', 'trailing-space' },
              groupSeverity = {
                strong = 'Warning',
                strict = 'Warning',
              },
              groupFileStatus = {
                ['ambiguity'] = 'Opened',
                ['await'] = 'Opened',
                ['codestyle'] = 'None',
                ['duplicate'] = 'Opened',
                ['global'] = 'Opened',
                ['luadoc'] = 'Opened',
                ['redefined'] = 'Opened',
                ['strict'] = 'Opened',
                ['strong'] = 'Opened',
                ['type-check'] = 'Opened',
                ['unbalanced'] = 'Opened',
                ['unused'] = 'Opened',
              },
              unusedLocalExclude = { '_*' },
            },
            format = {
              enable = false,
              defaultConfig = {
                indent_style = 'space',
                indent_size = '2',
                continuation_indent_size = '2',
              },
            },
          },
        },
      },
    },
  },
}
