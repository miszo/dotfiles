local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
  vim.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Add the LazyFile event for the lazy.nvim plugin manager
-- This event is used to trigger lazy loading of plugins based on file events.
local lazy_file_events = { 'BufReadPost', 'BufNewFile', 'BufWritePre' }
local Event = require('lazy.core.handler.event')

Event.mappings.LazyFile = { id = 'LazyFile', event = lazy_file_events }
Event.mappings['User LazyFile'] = Event.mappings.LazyFile

_G.UserUtil.lazyCoreUtil = require('lazy.core.util')

require('lazy').setup({
  { import = 'plugins.lsp' },
  { import = 'plugins' },
}, {
  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
  },
  install = {
    missing = true,
    colorscheme = { 'catppuccin' },
  },
  checker = {
    enabled = true,
    notify = true,
  },
  change_detection = {
    enabled = true,
    notify = true,
  },
  ui = {
    border = vim.g.border_style,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        'gzip',
        'zip',
        'zipPlugin',
        'tar',
        'tarPlugin',
        'getscript',
        'getscriptPlugin',
        'vimball',
        'vimballPlugin',
        '2html_plugin',
        'logipat',
        'rrhelper',
        'spellfile_plugin',
        'matchit',
      },
    },
  },
})
