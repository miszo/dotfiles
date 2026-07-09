---@type table<string, string>
local lsp_servers = {
  angularls = 'angular-language-server',
  astro = 'astro-language-server',
  bashls = 'bash-language-server',
  biome = 'biome',
  css_variables = 'css-variables-language-server',
  cssls = 'css-lsp',
  cssmodules_ls = 'cssmodules-language-server',
  docker_compose_language_service = 'docker-compose-language-service',
  dockerls = 'dockerfile-language-server',
  eslint = 'eslint-lsp',
  gopls = 'gopls',
  harper_ls = 'harper-ls',
  intelephense = 'intelephense',
  jsonls = 'json-lsp',
  lua_ls = 'lua-language-server',
  marksman = 'marksman',
  oxfmt = 'oxfmt',
  oxlint = 'oxlint',
  phpactor = 'phpactor',
  prismals = 'prisma-language-server',
  svelte = 'svelte-language-server',
  tailwindcss = 'tailwindcss-language-server',
  tsgo = 'tsgo',
  vtsls = 'vtsls',
  vue_ls = 'vue-language-server',
  yamlls = 'yaml-language-server',
  zls = 'zls',
}

---@type string[]
local lsp_ensure_installed = vim.tbl_values(lsp_servers)

---@type string[]
local linters_ensure_installed = {
  'erb-lint',
  'golangci-lint',
  'hadolint',
  'luacheck',
  'markdownlint-cli2',
  'phpcs',
  'shellcheck',
  'sqlfluff',
}

---@type string[]
local formatters_ensure_installed = {
  'blade-formatter',
  'erb-formatter',
  'gofumpt',
  'goimports',
  'markdown-toc',
  'php-cs-fixer',
  'prettierd',
  'rubocop',
  'shfmt',
  'stylua',
}

---@type string[]
local tools_ensure_installed =
  vim.tbl_extend('keep', lsp_ensure_installed, linters_ensure_installed, formatters_ensure_installed)

local function lsp_enable_list()
  local servers = vim.tbl_keys(lsp_servers)
  local typescript_lsp = UserUtil.lsp.get_typescript_server()

  servers = vim.tbl_filter(function(server)
    return server == typescript_lsp or not UserUtil.lsp.is_typescript_server(server)
  end, servers)

  table.sort(servers)
  return servers
end

---@module 'lazy'
---@type LazySpec[]
return {
  'mason-org/mason.nvim',
  lsp_enable = lsp_enable_list,
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
        border = vim.g.border_style,
      },
    })

    mason_tool_installer.setup({
      ensure_installed = tools_ensure_installed,
      run_on_start = true,
      integrations = {
        ['mason-lspconfig'] = false,
        ['mason-null-ls'] = false,
        ['mason-nvim-dap'] = false,
      },
    })
  end,
}
