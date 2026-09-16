# Neovim Config

Personal Neovim configuration built around `lazy.nvim`, native `vim.lsp.config`, Mason-managed tools, Snacks, Catppuccin, Treesitter, Conform, and focused language-specific plugin modules.

<a href="https://dotfyle.com/miszo/dotfiles-home-dotconfig-exactnvim"><img src="https://dotfyle.com/miszo/dotfiles-home-dotconfig-exactnvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/miszo/dotfiles-home-dotconfig-exactnvim"><img src="https://dotfyle.com/miszo/dotfiles-home-dotconfig-exactnvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/miszo/dotfiles-home-dotconfig-exactnvim"><img src="https://dotfyle.com/miszo/dotfiles-home-dotconfig-exactnvim/badges/plugin-manager?style=flat" /></a>

## Requirements

+ Neovim 0.12+
+ Git
+ A working shell environment with language runtimes needed by Mason packages

## Install

Clone the dotfiles repository:

```sh
git clone git@github.com:miszo/dotfiles ~/.config/miszo/dotfiles
```

Open Neovim with this config:

```sh
NVIM_APPNAME=miszo/dotfiles/home/dot_config/exact_nvim nvim
```

This config bootstraps `lazy.nvim` automatically from `lua/config/lazy.lua`. Mason tools are installed by `mason-tool-installer.nvim` on startup.

## Structure

+ `init.lua` loads the core config modules.
+ `lua/config/` contains options, keymaps, autocmds, Lazy setup, and global config objects.
+ `lua/plugins/` contains plugin specs grouped by domain.
+ `lua/plugins/lsp/` contains LSP infrastructure specs.
+ `lsp/` contains native Neovim LSP server configs.
+ `lua/util/` contains shared helpers exposed through `UserUtil`.
+ `lua/local_plugins/` contains local plugin shims/custom plugins.
+ `scripts/` contains maintenance scripts.

## Plugin Management

Plugins are managed by `lazy.nvim`.

Useful commands:

+ `:Lazy` opens the plugin manager.
+ `:Mason` opens Mason.
+ `:checkhealth vim.lsp` checks LSP health.
+ `:LspCapabilities` shows the current LSP capability health report.
+ `:Format` formats the current buffer through the configured formatter stack.
+ `:FormatInfo` shows formatter information for the current buffer.

## Maintenance

Check local LSP configs against upstream `nvim-lspconfig`:

```sh
scripts/check-lspconfig-drift
```

Check every local LSP config:

```sh
scripts/check-lspconfig-drift --all
```

Show drift for one server:

```sh
scripts/check-lspconfig-drift --diff lsp/tsc.lua
```

Validate startup and LSP health:

```sh
nvim --headless -u ~/.config/nvim/init.lua '+checkhealth vim.lsp' +qa
```

## Credits

+ [ThePrimeagen](https://github.com/ThePrimeagen), [TJ DeVries](https://github.com/tjdevries), [Chris Power](https://github.com/cpow), and [Adib Hanna](https://github.com/adibhanna) for their work in the Neovim community.
+ [folke](https://github.com/folke) for plugins and ecosystem work.
+ [echasnovski](https://github.com/echasnovski) for the `mini.nvim` plugin suite.
