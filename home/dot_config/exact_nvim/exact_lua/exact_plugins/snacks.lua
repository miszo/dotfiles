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

---@class snacks.explorer.Config
local explorer = {
  enabled = true,
  replace_netrw = true,
}

---@class snacks.image.Config
local image = {
  enabled = true,
}

---@class snacks.indent.Config
local indent = {
  enabled = true,
  blank = nil,
  only_scope = true,
  only_current = true,
}

---@param picker snacks.Picker
local explorer_trash = function(picker)
  local Tree = require('snacks.explorer.tree')
  local explorer_api = require('snacks.explorer.actions')
  if vim.fn.executable('trash') == 0 then
    vim.api.nvim_echo({
      { '- Trash utility not installed. Make sure to install it first\n', nil },
      { '- In macOS run `brew install trash`\n', nil },
      { '- Or delete the custom `explorer_trash` action in Snacks explorer', nil },
    }, false, {})
    return
  end
  ---@type string[]
  local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected({ fallback = true }))
  if #paths == 0 then
    return
  end
  local what = #paths == 1 and vim.fn.fnamemodify(paths[1], ':p:~:.') or #paths .. ' files'
  explorer_api.confirm('Trash ' .. what .. '?', function()
    for _, path in ipairs(paths) do
      local ok, err = pcall(function()
        vim.system({ 'trash', vim.fn.fnameescape(path) })
      end)
      if not ok then
        Snacks.notify.error('Failed to trash `' .. path .. '`:\n- ' .. err)
      end
      Tree:refresh(vim.fs.dirname(path))
    end
    picker.list:set_selected() -- clear selection
    explorer_api.update(picker)
  end)
end

---@class snacks.picker.Config
local picker = {
  enabled = true,
  sources = {
    explorer = {
      actions = {
        explorer_trash = explorer_trash,
      },
      win = {
        list = {
          keys = {
            ['d'] = 'explorer_trash',
          },
        },
      },
      hidden = true,
      layout = {
        preset = 'sidebar',
        layout = {
          position = 'right',
          max_width = 60,
        },
      },
    },
    files = {
      hidden = true,
    },
    git_files = {
      hidden = true,
    },
    grep = {
      hidden = true,
    },
    recent = {
      hidden = true,
    },
  },
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
  enabled = true,
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

---@class snacks.statuscolumn.Config
local statuscolumn = {
  enabled = true,
  folds = {
    open = true,
  },
}

---@class snacks.words.Config
local words = {
  enabled = true,
}

---@class snacks.zen.Config
local zen = {
  enabled = true,
  toggles = {
    dim = true,
    git_signs = true,
    mini_diff_signs = true,
    diagnostics = true,
    inlay_hints = false,
  },
}

---@module "lazy"
---@type LazySpec[]
return {
  {
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
      bigfile = bigfile,
      dashboard = dashboard,
      image = image,
      indent = indent,
      picker = picker,
      scratch = scratch,
      statuscolumn = statuscolumn,
      words = words,
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
  {
    'neovim/nvim-lspconfig',
    opts = function()
      local Keys = require('lazyvim.plugins.lsp.keymaps').get()
      vim.list_extend(Keys, {
        {
          '<leader>ss',
          function()
            Snacks.picker.lsp_symbols({
              filter = LazyVim.config.kind_filter,
              layout = { preset = 'vscode', preview = 'main' },
            })
          end,
          desc = 'LSP Symbols',
          has = 'documentSymbol',
        },
      })
    end,
  },
}
