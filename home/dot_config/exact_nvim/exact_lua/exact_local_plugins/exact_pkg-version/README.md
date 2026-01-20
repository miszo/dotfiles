# pkg-version.nvim

A modern package.json manager for Neovim with smart package manager detection, LSP progress integration, and snacks.nvim picker support.

## Features

✅ **Smart Package Manager Detection** - Auto-detects npm, yarn, pnpm, or bun from lockfiles with custom priority  
✅ **Virtual Text Display** - Show package versions inline with current vs latest comparison  
✅ **LSP Progress** - Integrates with noice.nvim's LSP progress for clean notifications  
✅ **Snacks Picker** - Version selection using snacks.nvim picker  
✅ **Smart Caching** - 5-minute cache with auto-refresh on save  
✅ **Full Package Management** - Install, update, delete, and change package versions  
✅ **Confirmation Prompts** - Safe operations with vim.ui.select confirmations  
✅ **Monorepo Support** - Workspace root detection for package manager

## Installation

Already configured in your `local_plugins.lua`. Restart Neovim to load.

## Usage

### Keymaps (in package.json files)

| Keymap | Action | Description |
|--------|--------|-------------|
| `<leader>ns` | Show | Show package versions inline |
| `<leader>nh` | Hide | Hide virtual text |
| `<leader>nn` | Toggle | Toggle package versions display |
| `<leader>nr` | Refresh | Force refresh versions from registry |
| `<leader>ni` | Install | Install a new package (prompts for name and type) |
| `<leader>nu` | Update | Update package on current line to latest |
| `<leader>nd` | Delete | Delete package on current line |
| `<leader>nv` | Version | Change version (opens snacks picker) |
| `<leader>n?` | Info | Show detected package manager |

### Commands

- `:PkgShow` - Show package versions
- `:PkgHide` - Hide package versions
- `:PkgToggle` - Toggle display
- `:PkgRefresh` - Refresh versions
- `:PkgInstall [package]` - Install package
- `:PkgUpdate` - Update package on line
- `:PkgDelete` - Delete package on line
- `:PkgChangeVersion` - Change package version
- `:PkgInfo` - Show package manager info

## Configuration

Default configuration (can be customized in `local_plugins.lua`):

```lua
{
  -- Package manager detection priority
  package_managers = {
    { file = 'bun.lockb', manager = 'bun' },
    { file = 'pnpm-lock.yaml', manager = 'pnpm' },
    { file = 'yarn.lock', manager = 'yarn' },
    { file = 'package-lock.json', manager = 'npm' },
  },
  fallback_manager = 'pnpm',
  
  -- Visual display
  virtual_text = {
    enabled = true,
    prefix = '  ',
    highlight = {
      up_to_date = 'Comment',
      outdated = 'DiagnosticWarn',
      latest = 'DiagnosticHint',
      error = 'DiagnosticError',
    },
  },
  
  -- Caching
  cache_ttl = 300, -- 5 minutes
  auto_refresh_on_save = true,
  
  -- Operations
  confirm_actions = true,
  autostart = true,
  
  -- Registry
  registry_timeout = 5000, -- 5 seconds
}
```

## How it Works

### Package Manager Detection

1. Searches workspace root for lockfiles (upward from current file)
2. Checks lockfiles in priority order
3. Falls back to configured default (pnpm)
4. Caches result per workspace for performance

### Version Display

- **Up to date**: `  v2.0.0 (latest) ✓` (gray)
- **Outdated**: `  v1.0.0 → v2.0.0 (latest)` (orange)
- **Error**: `  ✗ Failed to fetch` (red)

### Install Workflow

1. Prompt for package name (if not provided)
2. Select dependency type using snacks picker (dep/dev/peer)
3. Confirm action with vim.ui.select
4. Show LSP progress notification
5. Execute package manager command
6. Invalidate cache and refresh display

### Update Workflow

1. Detect package on current line
2. Confirm action
3. Show LSP progress
4. Update to latest version
5. Refresh display

### Change Version Workflow

1. Detect package on current line
2. Fetch available versions
3. Show snacks picker with all versions
4. Highlight current version and tags (latest, beta, etc.)
5. Install selected version
6. Refresh display

## Architecture

```
pkg-version/
├── init.lua              # Main API and setup
├── config.lua            # Configuration management
├── package_manager.lua   # Detection and command generation
├── parser.lua            # package.json parsing
├── registry.lua          # NPM registry API
├── cache.lua             # Version caching
├── operations.lua        # Install/update/delete operations
└── ui/
    ├── virtual_text.lua  # Inline version display
    ├── picker.lua        # Snacks picker integration
    └── progress.lua      # LSP progress reporting
```

## Advantages Over package-info.nvim

✅ Better package manager detection with custom priority  
✅ LSP progress integration (works with noice mini view)  
✅ Snacks picker for version selection  
✅ Standard vim.ui.select for confirmations  
✅ Smart caching with configurable TTL  
✅ Uses native package manager commands (respects .npmrc, etc.)  
✅ Full monorepo/workspace support  
✅ Cleaner codebase and better error handling  

## Troubleshooting

**Versions not showing?**
- Ensure you're in a package.json file
- Run `:PkgRefresh` to force re-fetch
- Check `:PkgInfo` to see detected package manager

**Wrong package manager?**
- Check lockfiles in your workspace root
- Verify package manager is installed: `which npm/pnpm/yarn/bun`
- Customize priority order in config

**Operations failing?**
- Check package manager is installed
- Verify you're in a valid npm project (has package.json)
- Look at `:messages` for detailed errors

## License

MIT
