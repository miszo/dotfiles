return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-jest',
      'nvim-neotest/neotest-go',
      'marilari88/neotest-vitest',
      'olimorris/neotest-rspec',
      'rouge8/neotest-rust',
      'nvim-neotest/nvim-nio',
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
          require('neotest').run.run_last({ strategy = 'dap' })
        end,
        desc = 'Debug Last Test',
      },
      {
        '<leader>tw',
        function()
          require('neotest').watch.toggle()
        end,
        desc = 'Watch tests',
      },
      {
        '<leader>tW',
        function()
          require('neotest').watch.toggle(vim.fn.expand('%'))
        end,
        desc = 'Watch tests in file',
      },
      {
        ']t',
        function()
          require('neotest').jump.next()
        end,
        desc = 'Jump to next test',
      },
      {
        '[t',
        function()
          require('neotest').jump.prev()
        end,
        desc = 'Jump to previous test',
      },
      {
        ']T',
        function()
          require('neotest').jump.next({ status = 'failed' })
        end,
        desc = 'Jump to next failed test',
      },
      {
        '[T',
        function()
          require('neotest').jump.prev({ status = 'failed' })
        end,
        desc = 'Jump to next failed test',
      },
    },
    opts = function(_, opts)
      opts.discovery = {
        enabled = false,
      }
      table.insert(
        opts.adapters,
        require('neotest-jest')({
          cwd = function()
            return vim.fn.getcwd()
          end,
          jest_test_discovery = true,
        })
      )
      table.insert(opts.adapters, require('neotest-vitest'))
      table.insert(opts.adapters, require('neotest-rust'))
      table.insert(opts.adapters, require('neotest-rspec'))
      table.insert(opts.adapters, require('neotest-go'))
    end,
  },
}
