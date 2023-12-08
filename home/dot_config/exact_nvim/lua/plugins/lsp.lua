local get_root_dir = function(fname)
  local util = require('lspconfig.util')
  return util.root_pattern('.git')(fname) or util.root_pattern('package.json', 'tsconfig.json')(fname)
end

return {
  -- tools
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'angular-language-server',
        'stylua',
        'selene',
        'luacheck',
        'shfmt',
        'tailwindcss-language-server',
        'typescript-language-server',
        'css-lsp',
      })
    end,
  },
  -- lsp servers
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'jose-elias-alvarez/typescript.nvim',
      'simrat39/rust-tools.nvim',
    },
    opts = {
      inlay_hints = { enabled = true },
      ---@type lspconfig.options
      servers = {
        cssls = {},
        rust_analyzer = {},
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
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = true, -- false
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true, -- false
              },
            },
            javascript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
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
        lua_ls = {
          single_file_support = true,
          settings = {
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
        },
        setup = {
          rust_analyzer = function(_, opts)
            require('rust-tools').setup({ server = opts })
            return true
          end,

          eslint = function()
            require('lazyvim.util').on_attach(function(client)
              if client.name == 'eslint' then
                client.server_capabilities.documentFormattingProvider = true
              elseif client.name == 'tsserver' then
                client.server_capabilities.documentFormattingProvider = false
              end
            end)
          end,
        },
      },
    },
  },
}
