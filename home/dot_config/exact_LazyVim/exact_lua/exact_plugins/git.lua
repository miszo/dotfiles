---@module "lazy"
---@type LazySpec[]
return {
  {
    'tpope/vim-fugitive',
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = function(_, opts)
      opts.current_line_blame = false
      opts.current_line_blame_opts = {
        delay = 300,
      }
    end,
    config = function(_, opts)
      require('gitsigns').setup(opts)
      vim.keymap.set(
        'n',
        '<leader>gt',
        ':Gitsigns toggle_current_line_blame<CR>',
        { desc = 'Toggle current line blame' }
      )
    end,
  },
  -- Generate link to file in the repository
  {
    'ruifm/gitlinker.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local callbacks = {}
      local gitlab_host = os.getenv('GITLINKER_GITLAB_HOST')
      if gitlab_host then
        callbacks[gitlab_host] = require('gitlinker.hosts').get_gitlab_type_url
      end

      require('gitlinker').setup({
        callbacks = callbacks,
      })
    end,
  },
}
