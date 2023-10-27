local get_root_dir = function(fname)
  local util = require('lspconfig.util')
  return util.root_pattern('.git')(fname) or util.root_pattern('package.json', 'tsconfig.json')(fname)
end

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
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
