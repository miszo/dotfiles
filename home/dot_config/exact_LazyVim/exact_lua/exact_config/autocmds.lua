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

-- Disable the diagnostics in files from ther `/node_modules/` directory
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'svelte', 'astro' },
  callback = function()
    if vim.fn.expand('%:p'):match('/node_modules/') then
      vim.diagnostic.enable(false)
    end
  end,
})

vim.api.nvim_create_user_command('LspCapabilities', ':checkhealth lsp-capabilities', { desc = 'Show LSP capabilities' })
