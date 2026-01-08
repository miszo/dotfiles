local Component = require('lualine.component'):extend()
local highlight = require('lualine.highlight')

local sidekick = require('lualine.components.sidekick.util')

---@class SidekickComponentOptions
local default_options = {
  symbols = {
    icon = UserConfig.icons.statusline.ai_sidekick, -- static icon when ready
    busy = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }, -- spinner frames
  },
  hl = {
    ready = Snacks.util.color('DiagnosticSignHint', 'fg'),
    busy = Snacks.util.color('Function', 'fg'),
  },
  spinner_speed = 80, -- milliseconds per frame
}

-- Spinner state
local spinner_frame = 1
local spinner_timer = nil

---Initialize component
---@override
---@param options SidekickComponentOptions
function Component:init(options)
  Component.super.init(self, options)
  self.options = vim.tbl_deep_extend('force', default_options, options or {})

  -- Create highlight groups
  self.hl_ready =
    highlight.create_component_highlight_group({ fg = self.options.hl.ready }, 'SidekickReady', self.options)
  self.hl_busy = highlight.create_component_highlight_group({ fg = self.options.hl.busy }, 'SidekickBusy', self.options)

  -- Setup spinner timer (only runs when needed)
  if not spinner_timer then
    spinner_timer = vim.uv.new_timer()
  end
end

---Start spinner animation
local function start_spinner()
  if spinner_timer and not spinner_timer:is_active() then
    spinner_timer:start(
      0,
      default_options.spinner_speed,
      vim.schedule_wrap(function()
        if sidekick.is_working() then
          spinner_frame = spinner_frame % #default_options.symbols.busy + 1
          require('lualine').refresh({ place = { 'statusline' } })
        else
          -- Stop timer when not working
          if spinner_timer then
            spinner_timer:stop()
          end
        end
      end)
    )
  end
end

---@override
function Component:update_status()
  -- Ensure we always have the icon available
  local sidekick_icon = self.options.symbols.icon

  -- Check if working on user action
  if sidekick.is_working() then
    start_spinner()
    local spinner_icon = self.options.symbols.busy[spinner_frame]
    return highlight.component_format_highlight(self.hl_ready)
      .. sidekick_icon
      .. highlight.component_format_highlight(self.hl_busy)
      .. spinner_icon
  end

  -- Show ready icon (default state - always visible)
  return highlight.component_format_highlight(self.hl_ready) .. sidekick_icon
end

return Component
