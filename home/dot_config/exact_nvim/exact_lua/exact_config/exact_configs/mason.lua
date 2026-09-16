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
  tsc = 'tsc',
  vue_ls = 'vue-language-server',
  yamlls = 'yaml-language-server',
  zls = 'zls',
}

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
local ensure_installed = vim.list_extend({}, lsp_ensure_installed)
vim.list_extend(ensure_installed, linters_ensure_installed)
vim.list_extend(ensure_installed, formatters_ensure_installed)

local M = {
  lsp_servers = lsp_servers,
  ensure_installed = ensure_installed,
}

return M
