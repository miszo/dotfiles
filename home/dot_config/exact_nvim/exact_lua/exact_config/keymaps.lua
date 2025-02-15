-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set('n', '<leader>dd', function()
  Snacks.terminal({ 'lazydocker' }, { cwd = LazyVim.root() })
end, { desc = 'Lazydocker' })

keymap.set('n', '<leader>R', function()
  Snacks.terminal({ 'posting' }, { cwd = LazyVim.root() })
end, { desc = 'Posting' })

-- Save file
keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>wa<cr><esc>', { desc = 'Save all opened files' })

-- Disable continuations
keymap.set('n', '<leader>o', 'o<Esc>^Da', opts)

-- Split window
keymap.set('n', 'ss', ':split<Return>', opts)
keymap.set('n', 'sv', ':vsplit<Return>', opts)

-- Move window
keymap.set('n', 'sh', '<C-w>h')
keymap.set('n', 'sk', '<C-w>k')
keymap.set('n', 'sj', '<C-w>j')
keymap.set('n', 'sl', '<C-w>l')

-- Resize window
keymap.set('n', '<C-w><left>', '<C-w><')
keymap.set('n', '<C-w><right>', '<C-w>>')
keymap.set('n', '<C-w><up>', '<C-w>+')
keymap.set('n', '<C-w><down>', '<C-w>-')

keymap.set('n', '<leader>r', function()
  require('utils.hsl').replaceHexWithHSL()
end, { desc = 'Replace hex with HSL' })
