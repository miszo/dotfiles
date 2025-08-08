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

---@module "lazy"
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
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          prefix = '',
          format = format_diagnostic,
          severity = {
            max = vim.diagnostic.severity.WARN,
          },
        },
        virtual_lines = {
          format = format_diagnostic,
          severity = {
            min = vim.diagnostic.severity.ERROR,
          },
        },
        underline = true,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = UserConfig.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = UserConfig.icons.diagnostics.Warn,
            [vim.diagnostic.severity.INFO] = UserConfig.icons.diagnostics.Info,
            [vim.diagnostic.severity.HINT] = UserConfig.icons.diagnostics.Hint,
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
            [vim.diagnostic.severity.WARN] = 'WarningMsg',
          },
        },
      })

      vim.lsp.config('*', {
        capabilities = (function()
          local capabilities = require('blink.cmp').get_lsp_capabilities()
          capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          }
          return capabilities
        end)(),
        flags = { debounce_text_changes = 150 },
        on_attach = function(client, _)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })

      -- Ruby LSP is not installed by mason.nvim, so we need to enable it manually
      vim.lsp.enable({ 'ruby_lsp' })

      vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx)
        require('ts-error-translator').translate_diagnostics(err, result, ctx)
        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
      end

      vim.api.nvim_create_user_command(
        'LspCapabilities',
        ':checkhealth lsp-capabilities',
        { desc = 'Show LSP capabilities' }
      )

      local formatter = UserUtil.lsp.formatter({
        name = 'eslint: lsp',
        primary = false,
        priority = 200,
        filter = 'eslint',
      })

      -- register the formatter with LazyVim
      UserUtil.formatting.register(formatter)
    end,
  },
}
