return {
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>O', '<cmd>Octo<cr>', desc = 'Octo' },
    },
    config = function()
      require('octo').setup({
        enable_builtin = true,
        gh_env = function()
          local github_token = require('op').get_secret('GitHub CLI token', 'token')
          if not github_token or not vim.startswith(github_token, 'gho_') then
            error('Failed to get GitHub token.')
          end

          return {
            GITHUB_TOKEN = github_token,
          }
        end,
      })
    end,
  },
}
