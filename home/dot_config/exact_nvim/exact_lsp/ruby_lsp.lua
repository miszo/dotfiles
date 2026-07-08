---@type vim.lsp.Config
return {
  mason = false,
  cmd = { 'ruby-lsp' },
  filetypes = { 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
  init_options = {
    bundleGemfile = vim.fn.expand('~/.config/ruby/Gemfile'),
    enabledFeatures = {
      'codeActions',
      'completion',
      'definition',
      'diagnostics',
      'documentHighlights',
      'documentLink',
      'documentSymbols',
      'foldingRanges',
      'formatting',
      'hover',
      'selectionRanges',
      'semanticHighlighting',
      'signatureHelp',
      'typeHierarchy',
      'workspaceSymbol',
    },
    experimentalFeaturesEnabled = false,
    formatter = 'auto',
    indexing = {
      excludedPatterns = {
        '**/test/**/*',
        '**/spec/**/*',
        '**/db/**/*',
        '**/vendor/**/*',
        '**/.git',
        '**/.svn',
        '**/.hg',
        '**/CVS',
        '**/.DS_Store',
        '**/tmp/**/*',
        '**/node_modules/**/*',
        '**/bower_components/**/*',
        '**/dist/**/*',
        '**/.git/objects/**',
        '**/.git/subtree-cache/**',
      },
    },
    addonSettings = {
      ['Ruby LSP Rails'] = {
        enablePendingMigrationsPrompt = false,
      },
    },
  },
  reuse_client = function(client, config)
    config.cmd_cwd = config.root_dir
    return client.name == config.name and client.config.root_dir == config.root_dir
  end,
}
