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
  return require('tiny-inline-diagnostic').open_float(...)
end

---@module 'tiny-inline-diagnostic'
---@param config PluginConfig
---@param multilines_enabled boolean
local function adjust_options_for_zen(config, multilines_enabled)
  config.options.multilines.enabled = multilines_enabled

  return config
end

---@param bufnr number
---@param multilines_enabled? boolean
function M.rerender(bufnr, multilines_enabled)
  local diag = require('tiny-inline-diagnostic')
  local diag_renderer = require('tiny-inline-diagnostic.renderer')

  -- if multilines_enabled is nil, use the current value of diag.config.options.multilines.enabled
  local enable_multilines = multilines_enabled == nil and diag.config.options.multilines.enabled or multilines_enabled
  local config = adjust_options_for_zen(diag.config, enable_multilines)

  diag_renderer.safe_render(config, bufnr)
end

function M.create_rerender_command()
  vim.api.nvim_create_user_command('RerenderDiagnostics', function()
    M.rerender(vim.api.nvim_get_current_buf())
  end, { desc = 'Rerender diagnostics for the current buffer' })
end

local disabled_diagnostics = false

function M.automatically_disable_diagnostics_for_nes()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'SidekickNesShow',
    callback = function()
      disabled_diagnostics = true
      require('tiny-inline-diagnostic').disable()
    end,
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'SidekickNesHide',
    callback = function()
      if disabled_diagnostics then
        disabled_diagnostics = false
        require('tiny-inline-diagnostic').enable()
      end
    end,
  })
end

return M
