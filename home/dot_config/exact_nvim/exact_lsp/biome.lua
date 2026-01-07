local util = require('lspconfig.util')

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'biome'
    local local_cmd = (config or {}).root_dir and config.root_dir .. '/node_modules/.bin/biome'
    if local_cmd and vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
    return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)
  end,
  filetypes = {
    'astro',
    'css',
    'graphql',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'svelte',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
    'vue',
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', { '.git' } }

    -- We fallback to the current working directory if no project root is found
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    -- We know that the buffer is using Biome if it has a config file
    -- in its directory tree.
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local biome_config_files = { 'biome.json', 'biome.jsonc' }
    biome_config_files = util.insert_package_json(biome_config_files, 'biomejs', filename)
    local is_buffer_using_biome = vim.fs.find(biome_config_files, {
      path = filename,
      type = 'file',
      limit = 1,
      upward = true,
      stop = vim.fs.dirname(project_root),
    })[1]
    if not is_buffer_using_biome then
      return
    end

    on_dir(project_root)
  end,
  on_attach = function(_, bufnr)
    -- Register a command to fix all issues in the current buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'LspBiomeFixAll', function()
      vim.lsp.buf.code_action({
        bufnr = bufnr,
        apply = true,
        context = { only = { 'source.fixAll.biome' } },
      })
    end, {})
  end,
}
