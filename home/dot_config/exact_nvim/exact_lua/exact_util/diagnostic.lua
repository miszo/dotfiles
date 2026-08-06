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

local nes_visible = false
local zen_active = false
local virtual_text_config

local function update_virtual_text()
  virtual_text_config = virtual_text_config or vim.diagnostic.config().virtual_text
  if type(virtual_text_config) ~= 'table' then
    return
  end

  local config = vim.deepcopy(virtual_text_config)
  config.current_line = zen_active and true or nil
  if nes_visible then
    vim.diagnostic.config({ virtual_text = false })
  else
    vim.diagnostic.config({ virtual_text = config })
  end
end

function M.set_nes_visible(visible)
  nes_visible = visible
  update_virtual_text()
end

function M.set_zen_active(active)
  zen_active = active
  update_virtual_text()
end

function M.automatically_disable_diagnostics_for_nes()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'SidekickNesShow',
    callback = function()
      M.set_nes_visible(true)
    end,
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'SidekickNesHide',
    callback = function()
      M.set_nes_visible(false)
    end,
  })
end

return M
