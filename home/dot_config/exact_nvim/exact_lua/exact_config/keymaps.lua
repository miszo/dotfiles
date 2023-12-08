-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require('lazyvim.util')
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set('n', '<leader>dd', function()
  Util.terminal({ 'lazydocker' }, { cwd = Util.root() })
end, { desc = 'Lazydocker' })

-- Save file
keymap.set({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>wa<cr><esc>', { desc = 'Save all opened files' })

-- Disable continuations
keymap.set('n', '<leader>o', 'o<Esc>^Da', opts)
keymap.set('n', '<leader>O', 'O<Esc>^Da', opts)

-- New tab
keymap.set('n', 'te', ':tabedit<Return>')
keymap.set('n', '<tab>', ':tabnext<Return>', opts)
keymap.set('n', '<s-tab>', ':tabprev<Return>', opts)

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
