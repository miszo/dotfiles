local function get_diagnostic_sign(severity)
  local diagnostic_signs = {
    [vim.diagnostic.severity.ERROR] = UserConfig.icons.diagnostics.Error,
    [vim.diagnostic.severity.WARN] = UserConfig.icons.diagnostics.Warn,
    [vim.diagnostic.severity.INFO] = UserConfig.icons.diagnostics.Info,
    [vim.diagnostic.severity.HINT] = UserConfig.icons.diagnostics.Hint,
  }
  return diagnostic_signs[severity]
end

local get_shorter_source_name = function(source)
  local shorter_source_names = {
    ['Lua Diagnostics.'] = 'Lua',
    ['Lua Syntax Check.'] = 'Lua',
    ['luacheck'] = 'LuaCheck',
    ['ts_error_translator'] = 'TS Error Translator',
    ['ruby_lsp'] = 'Ruby',
    ['eslint'] = 'ESLint',
    ['biome'] = 'Biome',
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
  return shorter_source_names[source] or source
end

local function format_diagnostic(diagnostic)
  if not diagnostic.source or not diagnostic.code then
    return string.format('%s %s', get_diagnostic_sign(diagnostic.severity), diagnostic.message)
  end
  return string.format(
    '%s %s (%s): %s',
    get_diagnostic_sign(diagnostic.severity),
    get_shorter_source_name(diagnostic.source),
    diagnostic.code,
    diagnostic.message
  )
end

---@type vim.diagnostic.Opts.VirtualText
local virtual_text = {
  spacing = 4,
  prefix = '',
  format = format_diagnostic,
}

---@return boolean|vim.diagnostic.Opts.VirtualText
local function get_virtual_text()
  if UserUtil.zen.is_zen_active() then
    return vim.tbl_extend('keep', virtual_text, { current_line = true })
  end
  return vim.tbl_extend('keep', virtual_text, { severity = { max = vim.diagnostic.severity.WARN } })
end

---@type vim.diagnostic.Opts.VirtualLines
local virtual_lines = {
  format = format_diagnostic,
  severity = {
    min = vim.diagnostic.severity.ERROR,
  },
}

---@return boolean|vim.diagnostic.Opts.VirtualLines
local function get_virtual_lines()
  if UserUtil.zen.is_zen_active() then
    return false
  end
  return virtual_lines
end

---@module 'lazy'
---@type LazySpec[]
return {
  {
    'neovim/nvim-lspconfig',
    event = 'LazyFile',
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'dmmulroy/ts-error-translator.nvim',
      'saghen/blink.cmp',
      'mrjones2014/codesettings.nvim',
    },
    config = vim.schedule_wrap(function()
      -- setup auto formatting with lsp
      UserUtil.formatting.register(UserUtil.lsp.formatter())

      vim.diagnostic.config({
        virtual_text = get_virtual_text,
        virtual_lines = get_virtual_lines,
        underline = true,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = UserConfig.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = UserConfig.icons.diagnostics.Warn,
            [vim.diagnostic.severity.INFO] = UserConfig.icons.diagnostics.Info,
            [vim.diagnostic.severity.HINT] = UserConfig.icons.diagnostics.Hint,
          },
          numhl = { [vim.diagnostic.severity.ERROR] = 'ErrorMsg', [vim.diagnostic.severity.WARN] = 'WarningMsg' },
        },
      })

      vim.lsp.config('lua_ls', {
        before_init = function(_, config)
          local codesettings = require('codesettings')
          config = codesettings.with_local_settings(config.name, config)
        end,
      })

      -- Ruby LSP is not installed by mason.nvim, so we need to enable it manually
      vim.lsp.enable({ 'ruby_lsp' }, true)

      vim.lsp.handlers[vim.lsp.protocol.Methods.textDocument_publishDiagnostics] = function(err, result, ctx)
        require('ts-error-translator').translate_diagnostics(err, result, ctx)
        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
      end

      if vim.lsp.is_enabled and vim.lsp.is_enabled('denols') and vim.lsp.is_enabled('vtsls') then
        ---@param server string
        local resolve = function(server)
          local markers, root_dir = vim.lsp.config[server].root_markers, vim.lsp.config[server].root_dir
          vim.lsp.config(server, {
            root_dir = function(bufnr, on_dir)
              local is_deno = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' }) ~= nil
              if is_deno == (server == 'denols') then
                if root_dir then
                  return root_dir(bufnr, on_dir)
                elseif type(markers) == 'table' then
                  local root = vim.fs.root(bufnr, markers)
                  return root and on_dir(root)
                end
              end
            end,
          })
        end
        resolve('denols')
        resolve('vtsls')
      end

      vim.api.nvim_create_user_command(
        'LspCapabilities',
        ':checkhealth lsp-capabilities',
        { desc = 'Show LSP capabilities' }
      )

      local eslint_formatter = UserUtil.lsp.formatter({
        name = 'eslint: lsp',
        primary = false,
        priority = 200,
        filter = 'eslint',
      })
      UserUtil.formatting.register(eslint_formatter)
    end),
  },
}
