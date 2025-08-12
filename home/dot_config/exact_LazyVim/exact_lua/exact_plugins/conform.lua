local root_pattern = require('lspconfig.util').root_pattern

local biome_or_prettier = function(bufnr)
  local has_biome_config = root_pattern('biome.json', 'biome.jsonc')(vim.api.nvim_buf_get_name(bufnr))

  if has_biome_config then
    return { 'biome', lsp_format = 'fallback' }
  end

  local has_prettier_config = root_pattern(
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.yml',
    '.prettierrc.yaml',
    '.prettierrc.json5',
    '.prettierrc.js',
    '.prettierrc.cjs',
    '.prettierrc.mjs',
    '.prettierrc.toml',
    'prettier.config.js',
    'prettier.config.cjs',
    'prettier.config.mjs'
  )(bufnr)

  if has_prettier_config then
    return { 'prettier', lsp_format = 'first' }
  end

  return { 'prettier', lsp_format = 'first' }
end

local filetypes_with_dynamic_formatter = {
  'astro',
  'svelte',
  'markdown',
  'graphql',
  'javascriptreact',
  'typescriptreact',
  'vue',
  'javascript',
  'json',
  'jsonc',
  'markdown.mdx',
  'handlebars',
  'typescript',
  'yaml',
  'css',
  'less',
  'scss',
  'html',
  'eruby',
}

---@module "lazy"
---@type LazySpec[]
return {
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.ruby = { vim.g.lazyvim_ruby_formatter }
      for _, ft in ipairs(filetypes_with_dynamic_formatter) do
        opts.formatters_by_ft[ft] = biome_or_prettier
      end
    end,
  },
}
