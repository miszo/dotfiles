-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require('lazyvim.util')
vim.keymap.set('n', '<leader>dd', function()
  Util.terminal({ 'lazydocker' }, { cwd = Util.root() })
end, { desc = 'Lazydocker' })

-- save file
vim.keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>wa<cr><esc>', { desc = 'Save file' })
