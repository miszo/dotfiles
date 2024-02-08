-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  command = 'set nopaste',
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json', 'jsonc', 'markdown' },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    local tasks = require('util.tasks')
    tasks.stop_all_task()
    tasks.dispose_all_tasks()
  end,
})

local set_kitty_layout_is_stack = vim.schedule_wrap(function()
  local layout = vim.fn.system('kitty @ kitten get_layout.py')
  vim.g.kitty_layout_is_stack = string.match(layout, 'stack')
end)

-- Check if we launched into neovim from kitty in scrollback mode
-- If so, jump to the bottom of the buffer
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    if vim.g.is_kitty_scrollback then
      vim.defer_fn(function()
        vim.cmd('normal G')
        vim.cmd("call search('.', 'bW')")
      end, 250)
    end

    set_kitty_layout_is_stack()
  end,
})

-- Reset is_kitty_scrollback on exit
vim.api.nvim_create_autocmd('VimLeave', {
  callback = function()
    vim.g.is_kitty_scrollback = nil
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  callback = set_kitty_layout_is_stack,
})
