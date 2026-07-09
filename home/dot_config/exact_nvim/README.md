# Neovim Config

Personal Neovim configuration built around `lazy.nvim`, native `vim.lsp.config`, Mason-managed tools, Snacks, Catppuccin, Treesitter, Conform, and focused language-specific plugin modules.

<a href="https://dotfyle.com/miszo/dotfiles-home-dotconfig-exactnvim"><img src="https://dotfyle.com/miszo/dotfiles-home-dotconfig-exactnvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/miszo/dotfiles-home-dotconfig-exactnvim"><img src="https://dotfyle.com/miszo/dotfiles-home-dotconfig-exactnvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/miszo/dotfiles-home-dotconfig-exactnvim"><img src="https://dotfyle.com/miszo/dotfiles-home-dotconfig-exactnvim/badges/plugin-manager?style=flat" /></a>

## Requirements

+ Neovim 0.11+
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

## LSP

LSP setup uses Neovim's native `vim.lsp.config` and `vim.lsp.enable` flow. Mason installs LSP servers, but `mason-lspconfig` integration is intentionally disabled.

Configured LSP servers:

+ `angularls`
+ `astro`
+ `bashls`
+ `biome`
+ `css_variables`
+ `cssls`
+ `cssmodules_ls`
+ `docker_compose_language_service`
+ `dockerls`
+ `eslint`
+ `gopls`
+ `harper_ls`
+ `intelephense`
+ `jsonls`
+ `lua_ls`
+ `marksman`
+ `oxfmt`
+ `oxlint`
+ `phpactor`
+ `prismals`
+ `ruby_lsp`
+ `svelte`
+ `tailwindcss`
+ `tsgo` or `vtsls`, selected by `vim.g.typescript_lsp`
+ `vue_ls`
+ `yamlls`
+ `zls`

`ruby_lsp` is enabled outside Mason. All other listed LSP servers are managed through Mason.

## TypeScript LSP

TypeScript can use either `tsgo` or `vtsls`. Only one is enabled at a time.

The active server is selected in `lua/config/options.lua`:

```lua
vim.g.typescript_lsp = 'tsgo'
```

Valid values:

+ `tsgo`, the current default
+ `vtsls`, the fallback/alternate server

Selection is centralized in `UserUtil.lsp.get_typescript_server()` and reused by:

+ Mason's LSP enable list
+ Deno/TypeScript root routing
+ Vue TypeScript request forwarding
+ TypeScript-specific keymaps
+ Nx import-specifier adjustment
+ `nvim-navic` LSP preference
+ TypeScript SDK path resolution

Both `lsp/tsgo.lua` and `lsp/vtsls.lua` include the same broad TypeScript preferences where possible. `vtsls` keeps custom command integrations that `tsgo` does not currently expose through `workspace/executeCommand`.

## Monorepos And Nx

TypeScript roots are intended to resolve at the workspace or monorepo root so references can work across libraries, not only within the nearest package.

Nx-specific import specifier behavior lives in `lua/util/nx.lua`. In Nx workspaces it updates TypeScript preferences dynamically:

+ files inside `apps/` or `libs/` prefer `project-relative`
+ workspace-level files prefer `non-relative`
+ `.vscode/settings.json` can override the import module specifier

The selected TypeScript LSP is notified with `workspace/didChangeConfiguration` after the setting changes.

## Formatting

Formatting is handled by `conform.nvim` plus LSP fallback.

For JavaScript and TypeScript-like filetypes, formatter selection is config-driven:

+ `oxfmt` is used when an oxfmt config exists.
+ `biome-check` is used when a Biome config exists.
+ `prettierd` is used when a Prettier config exists.
+ LSP formatting is used as fallback.

Other formatter tools installed by Mason include Blade, ERB, Go, Markdown TOC, PHP CS Fixer, RuboCop, Shell, and Stylua formatters.

## Linting

Linting uses `nvim-lint`.

Configured external linters:

+ Go: `golangci-lint`
+ Shell: `shellcheck`
+ PHP/Laravel: `pint --test`
+ SQL: `sqlfluff`

JavaScript and TypeScript filetypes intentionally have no `nvim-lint` linters configured to avoid conflicting with LSP diagnostics and language tooling.

## Diagnostics And UI

+ Diagnostics are configured in `lua/plugins/lsp/lsp.lua`.
+ Inline diagnostics use `rachartier/tiny-inline-diagnostic.nvim`.
+ LSP breadcrumbs use `nvim-navic` with the selected TypeScript server preference.
+ Statusline uses `lualine.nvim`.
+ File navigation and pickers are handled primarily through `snacks.nvim`.

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
scripts/check-lspconfig-drift --diff lsp/tsgo.lua
```

Validate startup and LSP health:

```sh
nvim --headless -u ~/.config/nvim/init.lua '+checkhealth vim.lsp' +qa
```

## Credits

+ [ThePrimeagen](https://github.com/ThePrimeagen), [TJ DeVries](https://github.com/tjdevries), [Chris Power](https://github.com/cpow), and [Adib Hanna](https://github.com/adibhanna) for their work in the Neovim community.
+ [folke](https://github.com/folke) for plugins and ecosystem work.
+ [echasnovski](https://github.com/echasnovski) for the `mini.nvim` plugin suite.
