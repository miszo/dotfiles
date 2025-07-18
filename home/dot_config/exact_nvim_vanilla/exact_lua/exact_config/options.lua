-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.opt.listchars = {
  space = '·',
  -- eol = '↲',
  nbsp = '␣',
  trail = '·',
  precedes = '←',
  extends = '→',
  tab = '¬ ',
  conceal = '※',
}

vim.opt.fillchars = {
  foldopen = '',
  foldclose = '',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ',
}

vim.spell = true
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.number = true
vim.opt.relativenumber = true
