local get_root_dir = function(fname)
  local util = require('lspconfig.util')
  return util.root_pattern('package.json', 'tsconfig.json')(fname) or util.root_pattern('.git')(fname)
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
        ltex = {
          cmd = { '/Users/miszo/.local/share/nvim/mason/bin/ltex-ls' },
          settings = {
            ltex = {
              enabled = true,
              language = 'en-US',
              checkFrequency = 'save',
              ['ltex-ls'] = {
                path = '/Users/miszo/.local/share/nvim/mason/bin/ltex-ls',
              },
              dictionary = {
                ['en-US'] = {},
                ['pl-PL'] = {},
              },
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
      },
      setup = {
        rust_analyzer = function(_, opts)
          require('rust-tools').setup({ server = opts })
          return true
        end,

        ltex = function(_, opts)
          local enPath =
            '/Users/miszo/Library/Application Support/Code/User/globalStorage/valentjn.vscode-ltex/ltex.dictionary.en-US.txt'
          local plPath =
            '/Users/miszo/Library/Application Support/Code/User/globalStorage/valentjn.vscode-ltex/ltex.dictionary.pl-PL.txt'

          for word in io.open(enPath, 'r'):lines() do
            table.insert(opts.settings.ltex.dictionary['en-US'], word)
          end

          for word in io.open(plPath, 'r'):lines() do
            table.insert(opts.settings.ltex.dictionary['pl-PL'], word)
          end
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
}
