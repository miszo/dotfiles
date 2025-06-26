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

vim.spell = true
vim.g.mapleader = ' '

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.title = true
vim.opt.titlelen = 20
vim.opt.titlestring = '%t - nvim'
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.list = true
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.shell = 'zsh'
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false -- No Wrap lines
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.path:append({ '**' }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ '*/node_modules/*' })
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitkeep = 'cursor'

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
vim.opt.formatoptions:append({ 'r' })

vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])

-- Code folding
vim.opt.foldenable = false

vim.lsp.set_log_level('OFF')

vim.g.local_plugins_path = vim.fn.stdpath('config') .. '/lua/local_plugins/'

-- LSP Server to use for Ruby.
-- Set to "solargraph" to use solargraph instead of ruby_lsp.
vim.g.lazyvim_ruby_lsp = 'ruby_lsp'
vim.g.lazyvim_ruby_formatter = 'rubocop'

-- LSP Server to use for PHP.
-- Set to "intelephense" to use intelephense instead of phpactor.
vim.g.lazyvim_php_lsp = 'intelephense'

-- Enable this option to avoid Biome conflicts with Prettier.
vim.g.lazyvim_prettier_needs_config = true

-- Set Snacks.picker as the default picker
vim.g.lazyvim_picker = 'snacks'

-- Enable lazydev
vim.g.lazydev_enabled = true

-- Disable AI completions and have them as a ghost text
vim.g.ai_cmp = false

-- Copilot models
vim.g.copilot_model = 'gpt-4o-copilot'
vim.g.copilot_chat_model = 'claude-3.7-sonnet'
