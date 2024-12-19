---@diagnostic disable: missing-fields
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

local scratch_delete_all = function()
  local items = Snacks.scratch.list()
  local count = #items

  if count == 0 then
    vim.notify('No scratch buffers to delete', 'info')
    return
  end

  for _, item in ipairs(items) do
    os.remove(item.file)
  end

  vim.notify('Deleted ' .. count .. ' scratch buffer(s)', 'info')
end

---@type snacks.win.Config
local ts_win = {
  keys = {
    ['source'] = {
      '<C-s>',
      '<cmd>Tsw rt=bun show_variables=true show_order=true<cr>',
      desc = 'Execute buffer',
      mode = { 'n', 'x' },
    },
    ['delete'] = {
      '<C-d>',
      function(self)
        local buf_name = vim.api.nvim_buf_get_name(self.buf)
        os.remove(buf_name)
        vim.api.nvim_buf_delete(self.buf, { force = true })
        vim.notify('Deleted scratch buffer' .. buf_name, 'info')
      end,
      desc = 'Delete buffer',
      mode = { 'n', 'x' },
    },
  },
}

---@class snacks.scratch.Config
local scratch = {
  root = vim.fn.stdpath('data') .. '/scratch',
  name = 'Scratch',
  actions = {},
  win = {
    width = 0.5,
    height = 0.9,
    style = 'scratch',
  },
  ft = function()
    if vim.bo.buftype == '' and vim.bo.filetype ~= '' then
      return vim.bo.filetype
    end
    return 'typescript'
  end,
  ---@type table<string, snacks.win.Config>
  win_by_ft = {
    lua = {
      keys = {
        ['source'] = {
          '<C-s>',
          function(self)
            local name = 'scratch.' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ':e')
            Snacks.debug.run({ buf = self.buf, name = name })
          end,
          desc = 'Source buffer',
          mode = { 'n', 'x' },
        },
      },
    },
    typescript = ts_win,
    javascript = ts_win,
  },
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
      scratch = scratch,
      zen = zen,
    },
    keys = {
      {
        '<leader>bs',
        scratch_delete_all,
        desc = 'Delete all scratch buffers',
      },
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
