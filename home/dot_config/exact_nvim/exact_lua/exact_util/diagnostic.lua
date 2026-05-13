local M = {}

local shorter_source_names = {
  ['Lua Diagnostics.'] = 'Lua',
  ['Lua Syntax Check.'] = 'Lua',
  ['luacheck'] = 'LuaCheck',
  ['ts_error_translator'] = 'TS Error Translator',
  ['ruby_lsp'] = 'Ruby',
  ['eslint'] = 'ESLint',
  ['biome'] = 'Biome',
  ['oxlint'] = 'Oxlint',
  ['pyright'] = 'Pyright',
  ['clangd'] = 'Clangd',
  ['rust_analyzer'] = 'Rust Analyzer',
  ['jdtls'] = 'Java',
  ['sumneko_lua'] = 'Lua',
  ['pylsp'] = 'Python LSP',
  ['bashls'] = 'Bash LSP',
  ['docker_compose_language_service'] = 'Docker Compose',
  ['dockerfile_language_server'] = 'Dockerfile',
  ['tsserver'] = 'TypeScript',
  ['jsonls'] = 'JSON',
  ['html-lsp'] = 'HTML',
  ['css-lsp'] = 'CSS',
  ['gopls'] = 'Go',
  ['dockerls'] = 'Docker',
  ['graphql'] = 'GraphQL',
  ['yaml-language-server'] = 'YAML',
  ['phpactor'] = 'PHP Actor',
}

local get_shorter_source_name = function(source)
  return shorter_source_names[source] or source
end

function M.format(diagnostic)
  if not diagnostic.source or not diagnostic.code then
    return diagnostic.message
  end
  return string.format('%s (%s: %s)', diagnostic.message, get_shorter_source_name(diagnostic.source), diagnostic.code)
end

function M.open_float(...)
  return require('tiny-inline-diagnostic.override').open_float(...)
end

local disabled = false

function M.automatically_disable_diagnostics_for_nes()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'SidekickNesHide',
    callback = function()
      if disabled then
        disabled = false
        require('tiny-inline-diagnostic').enable()
      end
    end,
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'SidekickNesShow',
    callback = function()
      disabled = true
      require('tiny-inline-diagnostic').disable()
    end,
  })
end

return M
