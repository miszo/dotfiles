local get_root_dir = function(...)
  local util = require('lspconfig.util')
  return util.root_pattern('package.json', 'tsconfig.json')(...) or util.root_pattern('.git')(...)
end

---@module "lazy"
---@type LazySpec[]
return {
  -- tools
  {
    'williamboman/mason.nvim',
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
      diagnostics = { virtual_text = { prefix = 'icons' } },
      inlay_hints = { enabled = false },
      servers = {
        cssls = {},
        sourcekit = {},
        ruby_lsp = {
          mason = false,
          cmd = { vim.fn.expand('~/.asdf/shims/ruby-lsp') },
          cmd_env = {
            BUNDLE_GEMFILE = vim.fn.expand('~/.ruby-lsp/Gemfile'),
          },
          init_options = {
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
              preferences = {
                importModuleSpecifier = 'non-relative',
              },
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
