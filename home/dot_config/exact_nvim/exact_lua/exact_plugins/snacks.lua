---@class snacks.bigfile.Config
local bigfile = { enabled = true }

---@class snacks.dashboard.Config
local dashboard = {
  width = 80,
  preset = {
    header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

[miszo]
 ]],
  },
  sections = {
    { section = 'header' },
    { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
    { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
    { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
    { section = 'startup' },
  },
}

---@class snacks.indent.Config
local indent = {
  blank = nil,
  only_scope = true,
  only_current = true,
}
---@class snacks.zen.Config
local zen = {
  toggles = {
    dim = true,
    git_signs = true,
    mini_diff_signs = true,
    diagnostics = true,
    inlay_hints = false,
  },
}

return {
  {
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
      bigfile = bigfile,
      dashboard = dashboard,
      indent = indent,
      zen = zen,
    },
    keys = {
      {
        '<leader>fN',
        function()
          Snacks.notifier.show_history()
        end,
        desc = 'Notification History',
      },
      {
        '<leader>z',
        function()
          Snacks.zen.zen()
        end,
        desc = 'Zen Mode',
      },
      {
        '<leader>Z',
        function()
          Snacks.zen.zoom()
        end,
        desc = 'Zoom Mode',
      },
    },
  },
}
