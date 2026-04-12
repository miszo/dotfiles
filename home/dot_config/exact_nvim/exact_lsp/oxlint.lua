local util = require('lspconfig.util')

---@type string[]
local oxlint_config_files = {
  '.oxlintrc.json',
  '.oxlintrc.jsonc',
  'oxlint.config.ts',
  'oxlint.config.mts',
  'oxlint.config.cts',
  'oxlint.config.js',
  'oxlint.config.mjs',
  'oxlint.config.cjs',
}

local function oxlint_conf_mentions_typescript(root_dir)
  local fn = vim.fs.joinpath(root_dir, '.oxlintrc.json')
  for line in io.lines(fn) do
    if line:find('typescript') then
      return true
    end
  end
  return false
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'oxlint'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, '--lsp' }, dispatchers)
  end,
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
    'astro',
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', { '.git' } }
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    local filename = vim.api.nvim_buf_get_name(bufnr)
    local config_files = util.insert_package_json(oxlint_config_files, 'oxlint', filename)
    local is_buffer_using_oxlint = vim.fs.find(config_files, {
      path = filename,
      type = 'file',
      limit = 1,
      upward = true,
      stop = vim.fs.dirname(project_root),
    })[1]
    if not is_buffer_using_oxlint then
      return
    end

    on_dir(project_root)
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspOxlintFixAll', function()
      client:exec_cmd({
        title = 'Apply Oxlint automatic fixes',
        command = 'oxc.fixAll',
        arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
      })
    end, {
      desc = 'Apply Oxlint automatic fixes',
    })
  end,
  settings = {},
  before_init = function(init_params, config)
    local settings = config.settings or {}
    if settings.typeAware == nil and vim.fn.executable('tsgolint') == 1 then
      local ok, res = pcall(oxlint_conf_mentions_typescript, config.root_dir)
      if ok and res then
        settings = vim.tbl_extend('force', settings, { typeAware = true })
      end
    end
    local init_options = config.init_options or {}
    init_options.settings = vim.tbl_extend('force', init_options.settings or {} --[[@as table]], settings)

    init_params.initializationOptions = init_options
  end,
}
