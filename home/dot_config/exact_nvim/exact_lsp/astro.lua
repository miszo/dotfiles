local util = require('lspconfig.util')

-- local astro_plugin = {
--   enableForWorkspaceTypeScriptVersions = true,
--   location = vim.fs.normalize(
--     vim.fs.joinpath(vim.fn.stdpath('data'), 'mason/packages/astro-language-server/node_modules/@astrojs/ts-plugin')
--   ),
--   name = '@astrojs/ts-plugin',
-- }

---@type vim.lsp.Config
return {
  cmd = { 'astro-ls', '--stdio' },
  filetypes = { 'astro' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  init_options = {
    typescript = {},
  },
  before_init = function(_, config)
    if config.init_options and config.init_options.typescript and not config.init_options.typescript.tsdk then
      ---@diagnostic disable-next-line: inject-field
      config.init_options.typescript.tsdk = util.get_typescript_server_path(config.root_dir)
    end
  end,
}
