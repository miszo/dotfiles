---@module 'lazy'
---@type LazySpec[]
return {
  {
    'mrjones2014/codesettings.nvim',
    opts = {
      config_file_paths = { '.vscode/settings.json', 'codesettings.json', 'lspsettings.json' },
      jsonls_integration = false,
      jsonc_filetype = false,
      root_dir = nil,
      default_merge_opts = {
        list_behavior = 'append',
      },
    },
    ft = { 'json', 'jsonc' },
  },
}
