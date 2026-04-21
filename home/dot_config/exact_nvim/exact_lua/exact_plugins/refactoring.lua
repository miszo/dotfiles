---@module 'lazy'
---@type LazySpec[]
return {
  {
    'ThePrimeagen/refactoring.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'lewis6991/async.nvim',
      {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
      },
    },
    keys = {
      { '<leader>r', '', desc = '+refactor', mode = { 'n', 'v' } },
      {
        '<leader>rs',
        function()
          require('refactoring').select_refactor()
        end,
        mode = { 'n', 'x' },
        desc = 'Select Refactor',
      },
      {
        '<leader>ri',
        function()
          return require('refactoring').inline_var()
        end,
        mode = { 'n', 'x' },
        expr = true,
        desc = 'Inline Variable',
      },
      {
        '<leader>rI',
        function()
          return require('refactoring').inline_func()
        end,
        mode = { 'n', 'x' },
        expr = true,
        desc = 'Inline Function',
      },
      {
        '<leader>rf',
        function()
          return require('refactoring').extract_func()
        end,
        mode = { 'n', 'x' },
        expr = true,
        desc = 'Extract Function',
      },
      {
        '<leader>rF',
        function()
          return require('refactoring').extract_func_to_file()
        end,
        mode = { 'n', 'x' },
        expr = true,
        desc = 'Extract Function To File',
      },
      {
        '<leader>rx',
        function()
          return require('refactoring').extract_var()
        end,
        mode = { 'n', 'x' },
        expr = true,
        desc = 'Extract Variable',
      },
      {
        '<leader>rP',
        function()
          return require('refactoring.debug').print_loc({ output_location = 'above' })
        end,
        expr = true,
        desc = 'Debug Print Location',
      },
      {
        '<leader>rp',
        function()
          return require('refactoring.debug').print_var({ output_location = 'below' })
        end,
        mode = { 'n', 'x' },
        expr = true,
        desc = 'Debug Print Variable',
      },
      {
        '<leader>rc',
        function()
          return require('refactoring.debug').cleanup({ restore_view = true })
        end,
        mode = { 'n', 'x' },
        expr = true,
        desc = 'Debug Cleanup',
      },
    },
    opts = {
      show_success_message = true,
    },
  },
}
