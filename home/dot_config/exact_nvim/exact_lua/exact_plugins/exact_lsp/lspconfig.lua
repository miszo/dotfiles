---@module 'lazy'
---@type LazySpec[]
return {
  {
    'neovim/nvim-lspconfig',
    event = 'LazyFile',
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'saghen/blink.cmp',
      'mrjones2014/codesettings.nvim',
    },
    config = vim.schedule_wrap(function()
      -- setup auto formatting with lsp
      UserUtil.formatting.register(UserUtil.lsp.formatter())

      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = false,
        underline = true,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = UserConfig.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = UserConfig.icons.diagnostics.Warn,
            [vim.diagnostic.severity.INFO] = UserConfig.icons.diagnostics.Info,
            [vim.diagnostic.severity.HINT] = UserConfig.icons.diagnostics.Hint,
          },
          numhl = { [vim.diagnostic.severity.ERROR] = 'ErrorMsg', [vim.diagnostic.severity.WARN] = 'WarningMsg' },
        },
        float = {
          border = vim.g.border_style,
        },
      })

      vim.lsp.config('lua_ls', {
        before_init = function(_, config)
          local codesettings = require('codesettings')
          config = codesettings.with_local_settings(config.name, config)
        end,
      })

      -- Ruby LSP is not installed by mason.nvim, so we need to enable it manually.
      -- We override cmd as a function (matching nvim-lspconfig's signature) so it
      -- wins the lsp/ruby_lsp.lua merge. Setting BUNDLE_GEMFILE + RUBYGEMS_GEMDEPS
      -- redirects ruby-lsp to a global Gemfile (~/.config/ruby/Gemfile) instead of
      -- composing with the project bundle.
      vim.lsp.config('ruby_lsp', {
        cmd = function(dispatchers, config)
          return vim.lsp.rpc.start({
            'env',
            'BUNDLE_GEMFILE=' .. vim.fn.expand('~/.config/ruby/Gemfile'),
            'RUBYGEMS_GEMDEPS=' .. vim.fn.expand('~/.config/ruby/Gemfile'),
            vim.fn.expand('~/.local/share/mise/shims/ruby-lsp'),
          }, dispatchers, config and config.root_dir and { cwd = config.cmd_cwd or config.root_dir })
        end,
      })
      vim.lsp.enable({ 'ruby_lsp' }, true)

      if vim.lsp.is_enabled and vim.lsp.is_enabled('denols') and vim.lsp.is_enabled('vtsls') then
        ---@param server string
        local resolve = function(server)
          local markers, root_dir = vim.lsp.config[server].root_markers, vim.lsp.config[server].root_dir
          vim.lsp.config(server, {
            root_dir = function(bufnr, on_dir)
              local is_deno = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' }) ~= nil
              if is_deno == (server == 'denols') then
                if root_dir then
                  return root_dir(bufnr, on_dir)
                elseif type(markers) == 'table' then
                  local root = vim.fs.root(bufnr, markers)
                  return root and on_dir(root)
                end
              end
            end,
          })
        end
        resolve('denols')
        resolve('vtsls')
      end

      vim.api.nvim_create_user_command(
        'LspCapabilities',
        ':checkhealth lsp-capabilities',
        { desc = 'Show LSP capabilities' }
      )

      local eslint_formatter = UserUtil.lsp.formatter({
        name = 'eslint: lsp',
        primary = false,
        priority = 200,
        filter = 'eslint',
      })
      UserUtil.formatting.register(eslint_formatter)
    end),
  },
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,

    ---@module 'tiny-inline-diagnostic'
    ---@type PluginConfig
    opts = {
      options = {
        use_icons_from_diagnostic = false,
        set_arrow_to_diag_color = true,
        multilines = {
          enabled = true,
          always_show = true,
          trim_whitespaces = true,
          tabstop = 4,
        },
        format = UserUtil.diagnostic.format,
        virt_texts = {
          priority = 5120,
        },
      },
    },
    config = function(_, opts)
      require('tiny-inline-diagnostic').setup(opts)
      vim.diagnostic.open_float = UserUtil.diagnostic.open_float
    end,
  },
}
