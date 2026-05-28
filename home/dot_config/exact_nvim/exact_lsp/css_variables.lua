---@type vim.lsp.Config
return {
  cmd = { 'css-variables-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_dir = function(bufnr, on_dir)
    local root_markers = { { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }, { '.git' } }
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
    on_dir(project_root)
  end,
  settings = {
    cssVariables = {
      lookupFiles = { '**/*.less', '**/*.scss', '**/*.sass', '**/*.css' },
      blacklistFolders = {
        '**/.cache',
        '**/.DS_Store',
        '**/.git',
        '**/.hg',
        '**/.next',
        '**/.svn',
        '**/bower_components',
        '**/CVS',
        '**/dist',
        '**/node_modules',
        '**/tests',
        '**/tmp',
      },
    },
  },
}
