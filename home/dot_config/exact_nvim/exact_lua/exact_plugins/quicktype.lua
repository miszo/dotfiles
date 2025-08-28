---@module 'lazy'
---@type LazySpec[]
return {
  {
    'midoBB/nvim-quicktype',
    build = 'npm install -g quicktype',
    cmd = 'QuickType',
    ft = { 'typescript', 'typescriptreact', 'go' },
    keys = {
      {
        '<leader>ct',
        '<cmd>QuickType<cr>',
        desc = 'Generate types from JSON',
      },
    },
    ---@module 'nvim-quicktype'
    ---@type Config
    opts = {
      ---@type GlobalConfig
      global = {
        alphabetize_properties = true,
      },
      ---@module 'nvim-quicktype'
      ---@type FileTypeConfig[]
      filetypes = {
        typescript = {
          lang = 'typescript',
          additional_options = {
            ['prefer-types'] = true,
            ['prefer-unions'] = true,
            ['just-types'] = true,
          },
        },
      },
    },
  },
}
