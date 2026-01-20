local M = {}

---@class PkgVersionConfig
M.defaults = {
  -- Package manager detection priority (first match wins)
  package_managers = {
    { file = 'bun.lockb', manager = 'bun' },
    { file = 'pnpm-lock.yaml', manager = 'pnpm' },
    { file = 'yarn.lock', manager = 'yarn' },
    { file = 'package-lock.json', manager = 'npm' },
  },
  fallback_manager = 'pnpm',

  -- Visual display
  virtual_text = {
    enabled = true,
    prefix = '| 󰏗 ', -- nerd font package icon
    hide_up_to_date = true, -- Only show outdated packages
    hide_unstable_versions = false, -- Show pre-release versions
    highlight = {
      up_to_date = 'Comment',
      outdated = 'Boolean',
      latest = 'DiagnosticHint',
      error = 'DiagnosticError',
    },
  },

  -- Caching
  cache_ttl = 300, -- 5 minutes in seconds
  auto_refresh_on_save = true,

  -- Operations
  confirm_actions = true, -- Prompt before install/update/delete
  autostart = true, -- Automatically show versions on package.json open
  notification_title = 'pkg-version.nvim', -- Title for all notifications

  -- Registry API
  registry_timeout = 5000, -- 5 seconds in milliseconds
}

---@type PkgVersionConfig
M.options = vim.deepcopy(M.defaults)

---Setup configuration
---@param user_config PkgVersionConfig?
function M.setup(user_config)
  M.options = vim.tbl_deep_extend('force', M.defaults, user_config or {})
end

---Helper function to show notifications with consistent title
---@param msg string Message to show
---@param level number vim.log.levels
function M.notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = M.options.notification_title })
end

return M
