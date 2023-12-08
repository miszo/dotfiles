return {
  {
    'klen/nvim-test',
    lazy = true,
    keys = {
      {
        '<leader>tl',
        function()
          vim.cmd(':TestLast')
        end,
        desc = 'Run Last Test',
      },
      {
        '<leader>ts',
        function()
          vim.cmd(':TestSuite')
        end,
        desc = 'Run Test Suite',
      },
      {
        '<leader>tn',
        function()
          vim.cmd(':TestNearest')
        end,
        desc = 'Run Nearest Test',
      },
      {
        '<leader>tf',
        function()
          vim.cmd(':TestFile')
        end,
        desc = 'Run Test File',
      },
      {
        '<leader>tt',
        function()
          vim.cmd(':TestVisit')
        end,
        desc = 'Visit Test File',
      },
    },
    config = true,
  },
}
