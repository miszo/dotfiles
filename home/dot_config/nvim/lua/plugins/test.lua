return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'haydenmeade/neotest-jest',
      'marilari88/neotest-vitest',
      'nvim-neotest/neotest-plenary',
      'nvim-neotest/neotest-vim-test',
      'rouge8/neotest-rust',
    },
    keys = {
      {
        '<leader>tl',
        function()
          require('neotest').run.run_last()
        end,
        desc = 'Run Last Test',
      },
      {
        '<leader>tL',
        function()
          require('neotest').run.run_last({ suite = false, strategy = 'dap' })
        end,
        desc = 'Debug Last Test',
      },
      {
        '<leader>tw',
        "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
        desc = 'Run Watch',
      },
    },
    opts = function(_, opts)
      table.insert(opts.adapters, require('neotest-vitest'))
      table.insert(opts.adapters, require('neotest-plenary'))
      table.insert(opts.adapters, require('neotest-rust'))
      table.insert(
        opts.adapters,
        require('neotest-jest')({
          jestCommand = 'yarn test',
          cwd = function()
            return vim.fn.getcwd()
          end,
        })
      )
      table.insert(
        opts.adapters,
        require('neotest-vim-test')({
          ignore_file_types = { 'python', 'vim', 'lua' },
        })
      )
    end,
  },
}
