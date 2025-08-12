local util = require('lspconfig.util')

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
