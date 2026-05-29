---@module 'lazy'
---@type LazySpec[]
return {
  {
    'miszo/package-info.nvim',
    event = 'BufRead',
    config = function()
      require('package-info').setup()
    end,
    keys = {
      { '<leader>n', '', desc = '+Package Manager' },
      {
        '<leader>ns',
        function()
          require('package-info').show()
        end,
        desc = 'Show versions',
      },
      {
        '<leader>nh',
        function()
          require('package-info').hide()
        end,
        desc = 'Hide versions',
      },
      {
        '<leader>nn',
        function()
          require('package-info').toggle()
        end,
        desc = 'Toggle versions',
      },
      {
        '<leader>nr',
        function()
          require('package-info').show({ force = true })
        end,
        desc = 'Refresh versions',
      },
      {
        '<leader>ni',
        function()
          require('package-info').install()
        end,
        desc = 'Install package',
      },
      {
        '<leader>nu',
        function()
          require('package-info').update()
        end,
        desc = 'Update package',
      },
      {
        '<leader>nd',
        function()
          require('package-info').delete()
        end,
        desc = 'Delete package',
      },
      {
        '<leader>nv',
        function()
          require('package-info').change_version()
        end,
        desc = 'Change version',
      },
    },
  },
}
