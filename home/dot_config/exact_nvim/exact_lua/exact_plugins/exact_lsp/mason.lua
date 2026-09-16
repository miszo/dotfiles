---@module 'lazy'
---@type LazySpec[]
return {
  'mason-org/mason.nvim',
  lsp_enable = function()
    return vim.tbl_keys(UserConfig.mason.lsp_servers)
  end,
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  build = ':MasonUpdate',
  keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local mason = require('mason')
    local mason_tool_installer = require('mason-tool-installer')

    mason.setup({
      ui = {
        border = vim.o.winborder,
      },
    })

    mason_tool_installer.setup({
      ensure_installed = UserConfig.mason.ensure_installed,
      run_on_start = true,
      integrations = {
        ['mason-lspconfig'] = false,
        ['mason-null-ls'] = false,
        ['mason-nvim-dap'] = false,
      },
    })
  end,
}
