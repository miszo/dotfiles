local get_gh_env = function()
  local github_token = os.getenv('OCTO_GH_TOKEN')
  if not github_token then
    error('Failed to get GitHub token.')
  end

  local start = string.find(github_token, 'gho_')
  if not start == 1 then
    error('Wrong GitHub token format. Please use a personal access token.')
  end

  return {
    GITHUB_TOKEN = github_token,
  }
end

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
  -- Octo - GitHub PRs and issues
  {
    'pwntester/octo.nvim',
    opts = function(_, opts)
      opts.gh_env = get_gh_env()
    end,
  },
  -- Generate link to file in the repository
  {
    'ruifm/gitlinker.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('gitlinker').setup()
    end,
  },
}
