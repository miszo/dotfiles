---@module 'lazy'
---@type LazySpec[]
return {
  {
    '2kabhishek/nerdy.nvim',
    dependencies = {
      'folke/snacks.nvim',
    },
    cmd = 'Nerdy',
    opts = {
      max_recents = 30, -- Configure recent icons limit
      copy_to_clipboard = false, -- Copy glyph to clipboard instead of inserting
      copy_register = '+', -- Register to use for copying (if `copy_to_clipboard` is true)
    },
    keys = {
      { '<leader>in', '<cmd>Nerdy list<CR>', desc = 'Browse nerd icons' },
      { '<leader>iN', '<cmd>Nerdy recents<CR>', desc = 'Browse recent nerd icons' },
    },
  },
}
