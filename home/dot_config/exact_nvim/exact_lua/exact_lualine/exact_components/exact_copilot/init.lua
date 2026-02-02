local Component = require('lualine.component'):extend()
local highlight = require('lualine.highlight')

local copilot = require('lualine.components.copilot.util')

---@class CopilotComponentOptions
local default_options = {
  symbols = {
    status = {
      icons = {
        enabled = UserConfig.icons.statusline.copilot,
        disabled = UserConfig.icons.statusline.copilot_stopped,
        warning = UserConfig.icons.statusline.copilot_warning,
        unknown = UserConfig.icons.statusline.copilot_stopped,
      },
      hl = {
        enabled = Snacks.util.color('DiagnosticSignHint', 'fg'),
        disabled = Snacks.util.color('Comment', 'fg'),
        warning = Snacks.util.color('Constant', 'fg'),
        unknown = Snacks.util.color('DiagnosticSignError', 'fg'),
      },
    },
  },
}

-- Whether copilot is attached to a buffer
local attached = false

---Initialize component
---@override
---@param options CopilotComponentOptions
function Component:init(options)
  Component.super.init(self, options)
  self.options = vim.tbl_deep_extend('force', default_options, options or {})

  self.hl = { enabled = {}, disabled = {}, warning = {} }

  self.hl.enabled = highlight.create_component_highlight_group(
    { fg = self.options.symbols.status.hl.enabled },
    'CopilotEnabled',
    self.options
  )
  self.hl.disabled = highlight.create_component_highlight_group(
    { fg = self.options.symbols.status.hl.disabled },
    'CopilotDisabled',
    self.options
  )
  self.hl.warning = highlight.create_component_highlight_group(
    { fg = self.options.symbols.status.hl.warning },
    'CopilotWarning',
    self.options
  )
  self.hl.unknown = highlight.create_component_highlight_group(
    { fg = self.options.symbols.status.hl.unknown },
    'CopilotUnknown',
    self.options
  )

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('miszo/copilot-status', {}),
    desc = 'Update copilot attached status',
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == 'copilot' then
        attached = true
        require('copilot.status').register_status_notification_handler(function()
          require('lualine').refresh()
        end)
        return true
      end
      return false
    end,
  })
end

---@override
function Component:update_status()
  -- All copilot API calls are blocking before copilot is attached,
  -- To avoid blocking the startup time, we check if copilot is attached
  local copilot_loaded = package.loaded['copilot'] ~= nil
  if not copilot_loaded or not attached then
    return highlight.component_format_highlight(self.hl.unknown) .. self.options.symbols.status.icons.unknown
  end

  if copilot.is_error() then
    return highlight.component_format_highlight(self.hl.warning) .. self.options.symbols.status.icons.warning
  elseif not copilot.is_enabled() then
    return highlight.component_format_highlight(self.hl.disabled) .. self.options.symbols.status.icons.disabled
  else
    return highlight.component_format_highlight(self.hl.enabled) .. self.options.symbols.status.icons.enabled
  end
end

return Component
