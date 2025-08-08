local root_pattern = require('lspconfig.util').root_pattern

local biome_or_prettier = function(bufnr)
  local has_biome_config = root_pattern('biome.json', 'biome.jsonc')(vim.api.nvim_buf_get_name(bufnr))

  if has_biome_config then
    return { 'biome' }
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
    return { 'prettierd', lsp_format = 'fallback' }
  end

  return { 'prettierd', lsp_format = 'fallback' }
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
    dependencies = { 'mason.nvim' },
    cmd = 'ConformInfo',
    event = 'BufReadPre',
    keys = {
      {
        '<leader>cF',
        function()
          require('conform').format({ formatters = { 'injected' }, timeout_ms = 3000 })
        end,
        mode = { 'n', 'v' },
        desc = 'Format Injected Langs',
      },
    },
    init = function()
      -- Install the conform formatter on VeryLazy
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          UserUtil.formatting.register({
            name = 'conform.nvim',
            priority = 100,
            primary = true,
            format = function(buf)
              require('conform').format({ bufnr = buf })
            end,
            sources = function(buf)
              local ret = require('conform').list_formatters(buf)
              ---@param v conform.FormatterInfo
              return vim.tbl_map(function(v)
                return v.name
              end, ret)
            end,
          })
        end,
      })
    end,
    opts = function(_, opts)
      opts.formatters_by_ft = {
        go = { 'goimports', 'gofmt' },
        lua = { 'stylua' },
        ruby = { 'rubocop' },
        python = { 'isort', 'black' },
        php = { 'pint' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
      }
      for _, ft in ipairs(filetypes_with_dynamic_formatter) do
        opts.formatters_by_ft[ft] = biome_or_prettier
      end
      opts.default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = 'fallback', -- not recommended to change
      }
      opts.formatters = {
        injected = { options = { ignore_errors = true } },
      }
    end,
    config = function(_, opts)
      require('conform').setup(opts)
    end,
  },
}
