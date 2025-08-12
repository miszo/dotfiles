local sql_ft = { 'sql', 'mysql', 'plsql' }
---@module 'lazy'
---@type LazySpec[]
return {
  {
    'tpope/vim-dadbod',
    cmd = 'DB',
  },
  {
    'kristijanhusak/vim-dadbod-completion',
    dependencies = 'vim-dadbod',
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    dependencies = 'vim-dadbod',
    keys = {
      { '<leader>D', '<cmd>DBUIToggle<CR>', desc = 'Toggle DBUI' },
    },
    init = function()
      local data_path = vim.fn.stdpath('data')

      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = data_path .. '/dadbod_ui'
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_tmp_query_location = data_path .. '/dadbod_ui/tmp'
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true

      -- NOTE: The default behavior of auto-execution of queries on save is disabled
      -- this is useful when you have a big query that you don't want to run every time
      -- you save the file running those queries can crash neovim to run use the
      -- default keymap: <leader>S
      vim.g.db_ui_execute_on_save = false
    end,
  },
  -- Edgy integration
  {
    'folke/edgy.nvim',
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = 'Database',
        ft = 'dbui',
        pinned = true,
        width = 0.3,
        open = function()
          vim.cmd('DBUI')
        end,
      })

      opts.bottom = opts.bottom or {}
      table.insert(opts.bottom, {
        title = 'DB Query Result',
        ft = 'dbout',
      })
    end,
  },
}
