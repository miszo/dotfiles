local Component = require('lualine.component'):extend()
local highlight = require('lualine.highlight')

Component.processing = false
Component.spinner_index = 1

local default_options = {
  codecompanion_icon = UserConfig.icons.statusline.codecompanion,
  spinner_symbols = {
    '⠋',
    '⠙',
    '⠹',
    '⠸',
    '⠼',
    '⠴',
    '⠦',
    '⠧',
    '⠇',
    '⠏',
  },
}

-- Initializer
function Component:init(options)
  Component.super.init(self, options)
  self.options = vim.tbl_deep_extend('force', default_options, options)

  self.hl = { icon = {}, spinner = {} }

  self.hl.icon = highlight.create_component_highlight_group(
    { fg = Snacks.util.color('DiagnosticSignHint', 'fg') },
    'CodeCompanionIcon',
    self.options
  )

  self.hl.spinner = highlight.create_component_highlight_group(
    { fg = Snacks.util.color('Function', 'fg') },
    'CodeCompanionSpinner',
    self.options
  )

  local group = vim.api.nvim_create_augroup('CodeCompanionHooks', {})

  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'CodeCompanionRequest*',
    group = group,
    callback = function(request)
      if request.match == 'CodeCompanionRequestStarted' then
        self.processing = true
      elseif request.match == 'CodeCompanionRequestFinished' then
        self.processing = false
      end
    end,
  })
end

-- Function that runs every time statusline is updated
function Component:update_status()
  if self.processing then
    self.spinner_index = (self.spinner_index % #self.options.spinner_symbols) + 1
    return highlight.component_format_highlight(self.hl.icon)
      .. self.options.codecompanion_icon
      .. highlight.component_format_highlight(self.hl.spinner)
      .. self.options.spinner_symbols[self.spinner_index]
  else
    return highlight.component_format_highlight(self.hl.icon) .. self.options.codecompanion_icon
  end
end

return Component
