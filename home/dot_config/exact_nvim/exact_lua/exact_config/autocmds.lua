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

vim.api.nvim_create_autocmd('VimLeave', {
  callback = function()
    local has_zen_mode, zen_mode = pcall(require, 'zen-mode')
    if not has_zen_mode then
      return
    end

    zen_mode.close()
  end,
})
