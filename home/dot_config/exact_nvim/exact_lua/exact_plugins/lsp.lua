local get_root_dir = function(...)
  local util = require('lspconfig.util')
  return util.root_pattern('package.json', 'tsconfig.json')(...) or util.root_pattern('.git')(...)
end

return {
  -- tools
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'angular-language-server',
        'css-lsp',
        'luacheck',
        'ltex-ls',
        'solargraph',
        'selene',
        'shfmt',
        'stylua',
        'tailwindcss-language-server',
        'typescript-language-server',
      })
    end,
  },
  -- lsp servers
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'jose-elias-alvarez/typescript.nvim',
      'simrat39/rust-tools.nvim',
      'barreiroleo/ltex_extra.nvim',
    },
    ---@class PluginLspOpts
    opts = {
      inlay_hints = { enabled = false },
      ---@type lspconfig.options
      servers = {
        cssls = {},
        eslint = {
          root_dir = get_root_dir,
        },
        tsserver = {
          root_dir = get_root_dir,
          single_file_support = false,
          init_options = {
            preferences = {
              allowRenameOfImportPath = true,
              importModuleSpecifierPreference = 'non-relative',
              includeCompletionsForModuleExports = true,
              includeCompletionsForImportStatements = true,
            },
          },
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        html = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        ltex = {
          cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/ltex-ls') },
          settings = {
            ltex = {
              enabled = true,
              language = 'en-US',
              checkFrequency = 'save',
              additionalRules = {
                enablePickyRules = true,
                motherTongue = 'pl-PL',
              },
              configurationTarget = {
                dictionary = 'userExternalFile',
                disabledRules = 'userExternalFile',
                hiddenFalsePositives = 'userExternalFile',
              },
            },
          },
        },
        lua_ls = {
          single_file_support = true,
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              workspaceWord = true,
              callSnippet = 'Both',
            },
            misc = {
              parameters = {},
            },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = 'Disable',
              semicolon = 'Disable',
              arrayIndex = 'Disable',
            },
            doc = {
              privateName = { '^_' },
            },
            type = {
              castNumberToInteger = true,
            },
            diagnostics = {
              disable = { 'incomplete-signature-doc', 'trailing-space' },
              -- enable = false,
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
        solargraph = {},
      },
      setup = {
        rust_analyzer = function(_, opts)
          require('rust-tools').setup({ server = opts })
          return true
        end,

        ltex = function(_, opts)
          opts.on_attach = function(_, _)
            require('ltex_extra').setup({
              load_langs = { 'en-US', 'pl-PL' },
              path = vim.fn.expand('~/.config/spell/dictionaries'),
            })
          end
        end,
      },
    },
  },
  -- lsp file operations
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neo-tree/neo-tree.nvim',
    },
    config = function()
      require('lsp-file-operations').setup()
    end,
  },
}
