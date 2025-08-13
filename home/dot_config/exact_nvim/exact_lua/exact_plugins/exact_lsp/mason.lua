---@module 'lazy'
---@type LazySpec[]
return {
  'mason-org/mason.nvim',
  dependencies = {
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local mason = require('mason')
    local mason_lspconfig = require('mason-lspconfig')
    local mason_tool_installer = require('mason-tool-installer')

    mason.setup({
      ui = {
        border = 'rounded',
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        'angularls',
        'astro',
        'bashls',
        'biome',
        'css_variables',
        'cssls',
        'cssmodules_ls',
        'docker_compose_language_service',
        'dockerls',
        'eslint',
        'gopls',
        'intelephense',
        'jsonls',
        'lua_ls',
        'marksman',
        'phpactor',
        'prismals',
        'svelte',
        'tailwindcss',
        'vtsls',
        'vue_ls',
        'yamlls',
        'zls',
      },
      automatic_installation = true,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        -- linter
        'erb-lint',
        -- 'hadolint',
        'luacheck',
        'markdownlint-cli2',
        'phpcs',
        'shellcheck',
        'sqlfluff',
        -- formatter
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
      },
      run_on_start = true,
    })

    vim.keymap.set('n', '<leader>cm', '<cmd>Mason<cr>', { desc = 'Mason' })
  end,
}
