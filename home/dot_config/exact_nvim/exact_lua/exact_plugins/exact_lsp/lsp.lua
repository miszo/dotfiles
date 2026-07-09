---@module 'lazy'
---@type LazySpec[]
return {
  {
    name = 'native-lsp',
    dir = vim.fn.stdpath('config'),
    event = 'LazyFile',
    dependencies = {
      'mason-org/mason.nvim',
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

      local mason_lsp_spec = UserUtil.plugins.get('mason.nvim') or {}
      local mason_lsp_enable = type(mason_lsp_spec.lsp_enable) == 'function' and mason_lsp_spec.lsp_enable() or {}
      local non_mason_lsp_enable = { 'ruby_lsp' }

      vim.lsp.enable(vim.list_extend(mason_lsp_enable, non_mason_lsp_enable), true)

      local typescript_lsp = UserUtil.lsp.get_typescript_server()
      if vim.lsp.is_enabled and vim.lsp.is_enabled('denols') and vim.lsp.is_enabled(typescript_lsp) then
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
        resolve(typescript_lsp)
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
