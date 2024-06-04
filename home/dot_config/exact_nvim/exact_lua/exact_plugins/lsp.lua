local get_root_dir = function(...)
  local util = require('lspconfig.util')
  return util.root_pattern('package.json', 'tsconfig.json')(...) or util.root_pattern('.git')(...)
end

return {
  -- tools
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.tbl_deep_extend('force', {}, opts.ensure_installed, {
        'angular-language-server',
        'css-lsp',
        'luacheck',
        'solargraph',
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
    ---@class PluginLspOpts
    opts = {
      inlay_hints = { enabled = true },
      servers = {
        cssls = {},
        eslint = {
          root_dir = get_root_dir,
        },
        tsserver = {
          enabled = false,
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
