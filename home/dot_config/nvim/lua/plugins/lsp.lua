local get_root_dir = function(fname)
  local util = require('lspconfig.util')
  return util.root_pattern('.git')(fname) or util.root_pattern('package.json', 'tsconfig.json')(fname)
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'jose-elias-alvarez/typescript.nvim',
      'simrat39/rust-tools.nvim',
    },
    opts = {
      servers = {
        rust_analyzer = {},
        eslint = {
          root_dir = get_root_dir,
        },
        tsserver = {
          root_dir = get_root_dir,
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
                -- taken from https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
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
