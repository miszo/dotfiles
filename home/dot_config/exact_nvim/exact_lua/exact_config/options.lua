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
vim.g.autoformat = true -- Enable autoformatting by default

vim.scriptencoding = 'utf-8'
vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'

vim.o.signcolumn = 'yes'
vim.o.number = true
vim.o.relativenumber = true

-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
vim.o.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus' -- Sync with system clipboard

vim.o.autowrite = true
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.conceallevel = 2 -- Hide text in markdown, etc.
vim.o.confirm = true -- Confirm before overwriting files
vim.o.cursorline = true -- Highlight the current line
vim.o.expandtab = true -- Use spaces instead of tabs

vim.o.smoothscroll = true
vim.o.foldlevel = 99 -- Open all folds by default
vim.o.foldmethod = 'expr' -- Use indentation for folding
vim.o.foldexpr = "v:lua.require'util'.ui.foldexpr()"
vim.o.foldtext = ''

vim.o.grepformat = '%f:%l:%c:%m' -- Format for grep results
vim.o.grepprg = 'rg --vimgrep'

vim.o.ignorecase = true -- Ignore case in search patterns
vim.o.smartcase = true -- Override ignorecase if search pattern contains uppercase letters

vim.o.inccommand = 'nosplit' -- Show live command preview
vim.o.jumpoptions = 'view' -- Jump to previous location in jump list
vim.o.laststatus = 3 -- Global status line
vim.o.linebreak = true -- Break long lines at word boundaries
vim.o.list = true -- Show whitespace characters
vim.o.mouse = 'a' -- Enable mouse support in all modes
vim.o.pumblend = 10 -- Make popup menu slightly transparent
vim.o.pumheight = 10 -- Limit popup menu height
vim.o.scrolloff = 8 -- Keep 8 lines visible above/below cursor
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' } -- Options to save in session files
vim.o.shiftround = true -- Round indent to multiple of 'shiftwidth'
vim.o.shiftwidth = 2 -- Number of spaces for each indentation level
vim.o.showmode = true -- Don't show mode in command line
vim.o.smartindent = true -- Smart indentation
vim.o.splitbelow = true -- New horizontal splits appear below the current window
vim.o.splitkeep = 'cursor' -- Keep the same cursor position when splitting windows
vim.o.splitright = true -- New vertical splits appear to the right of the current window
vim.o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
vim.o.tabstop = 2 -- Number of spaces for a tab character
vim.o.termguicolors = true -- Enable true color support
vim.o.timeoutlen = 300 -- Time to wait for a mapped sequence to complete
vim.o.undofile = true -- Enable persistent undo
vim.o.undolevels = 10000 -- Number of undo levels to keep
vim.o.updatetime = 200 -- Time in milliseconds to wait before triggering CursorHold
vim.o.virtualedit = 'block' -- Allow cursor to move in block mode
vim.o.wildmode = 'longest:full,full' -- Use longest common prefix for command completion
vim.o.winminwidth = 5 -- Minimum width of a window
vim.o.wrap = false -- Disable line wrapping

vim.o.formatexpr = "v:lua.require'util'.formatting.formatexpr()"

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
vim.opt.formatoptions:append({ 'r' })

vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])

vim.lsp.set_log_level('OFF')

vim.g.local_plugins_path = vim.fn.stdpath('config') .. '/lua/local_plugins/'
