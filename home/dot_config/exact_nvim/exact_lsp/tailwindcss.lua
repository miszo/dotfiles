---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'tailwindcss-language-server'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
  filetypes = {
    'astro',
    'blade',
    'css',
    'eruby',
    'html',
    'htmlangular',
    'javascript',
    'javascriptreact',
    'less',
    'markdown',
    'mdx',
    'php',
    'scss',
    'svelte',
    'typescript',
    'typescriptreact',
    'vue',
  },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = { dynamicRegistration = true },
    },
  },
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = 'warning',
        invalidApply = 'error',
        invalidScreen = 'error',
        invalidVariant = 'error',
        invalidConfigPath = 'error',
        invalidTailwindDirective = 'error',
        recommendedVariantOrder = 'warning',
      },
      classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass' },
      includeLanguages = {
        eruby = 'erb',
        htmlangular = 'html',
      },
    },
  },
  before_init = function(_, config)
    config.settings = vim.tbl_deep_extend('keep', config.settings, {
      editor = { tabSize = vim.lsp.util.get_effective_tabstop() },
    })
  end,
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_files = {
      'tailwind.config.js',
      'tailwind.config.cjs',
      'tailwind.config.mjs',
      'tailwind.config.ts',
      'postcss.config.js',
      'postcss.config.cjs',
      'postcss.config.mjs',
      'postcss.config.ts',
      'theme/static_src/tailwind.config.js',
      'theme/static_src/tailwind.config.cjs',
      'theme/static_src/tailwind.config.mjs',
      'theme/static_src/tailwind.config.ts',
      'theme/static_src/postcss.config.js',
      '.git',
    }
    root_files = UserUtil.lsp.insert_package_json(root_files, 'tailwindcss', fname)
    root_files = UserUtil.lsp.root_markers_with_field(root_files, { 'mix.lock', 'Gemfile.lock' }, 'tailwind', fname)
    local root_file = vim.fs.find(root_files, { path = fname, upward = true })[1]
    if root_file then
      on_dir(vim.fs.dirname(root_file))
    end
  end,
}
