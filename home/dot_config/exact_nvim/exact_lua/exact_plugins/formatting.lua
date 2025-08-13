local formatter_root_markers = {
  biome = { 'biome.json', 'biome.jsonc' },
  prettier = {
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
    'prettier.config.mjs',
  },
}

---@param formatter string
local function has_formatter_config(formatter)
  local has_config = next(vim.fs.find(formatter_root_markers[formatter], { upward = true }))
  return has_config ~= nil
end

local get_js_formatter = function()
  local has_biome_config = has_formatter_config('biome')
  local has_prettier_config = has_formatter_config('prettier')

  if has_biome_config then
    return { 'biome-check' }
  end

  if has_prettier_config then
    return { 'prettierd', lsp_format = 'fallback' }
  end

  -- fallback to lsp formatting
  return { lsp_format = 'fallback' }
end

local ft_with_js_formatter = {
  'astro',
  'svelte',
  'graphql',
  'javascriptreact',
  'typescriptreact',
  'vue',
  'javascript',
  'json',
  'jsonc',
  'typescript',
}

local ft_with_prettier = {
  'markdown',
  'markdown.mdx',
  'handlebars',
  'yaml',
  'css',
  'less',
  'scss',
  'html',
  'eruby',
}

local sql_ft = { 'sql', 'mysql', 'plsql' }

local prettier_or_lsp = function()
  local has_prettier_config = has_formatter_config('prettier')
  if has_prettier_config then
    return { 'prettierd', lsp_format = 'fallback' }
  end
  return { lsp_format = 'fallback' }
end

---@module 'lazy'
---@type LazySpec[]
return {
  {
    'stevearc/conform.nvim',
    dependencies = { 'mason.nvim' },
    cmd = 'ConformInfo',
    event = 'BufReadPre',
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format({ timeout_ms = 3000 })
        end,
        mode = { 'n', 'v' },
        desc = 'Format buffer',
      },
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
      for _, ft in ipairs(ft_with_js_formatter) do
        opts.formatters_by_ft[ft] = get_js_formatter()
      end
      for _, ft in ipairs(ft_with_prettier) do
        opts.formatters_by_ft[ft] = prettier_or_lsp()
      end
      for _, ft in ipairs(sql_ft) do
        opts.formatters_by_ft[ft] = { 'sqlfluff' }
      end
      opts.default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = 'fallback', -- not recommended to change
      }
      opts.formatters = {
        injected = { options = { ignore_errors = true } },
        sqlfluff = {
          args = { 'format', '--dialect=ansi', '-' },
        },
      }
    end,
    config = function(_, opts)
      require('conform').setup(opts)
    end,
  },
}
