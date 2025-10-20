---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == 'function' and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == 'table' and table.concat(args, ' ') or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input('Run with args: ', args_str)) --[[@as string]]
    if config.type and config.type == 'java' then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require('dap.utils').splitstr(new_args)
  end
  return config
end

---@module 'lazy'
---@type LazySpec[]
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      -- virtual text for the debugger
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
      'mason-org/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'leoluz/nvim-dap-go',
    },
    keys = {
      {
        '<leader>dB',
        function()
          require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
        end,
        desc = 'Breakpoint Condition',
      },
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle Breakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = 'Run/Continue',
      },
      {
        '<leader>da',
        function()
          require('dap').continue({ before = get_args })
        end,
        desc = 'Run with Args',
      },
      {
        '<leader>dC',
        function()
          require('dap').run_to_cursor()
        end,
        desc = 'Run to Cursor',
      },
      {
        '<leader>dg',
        function()
          require('dap').goto_()
        end,
        desc = 'Go to Line (No Execute)',
      },
      {
        '<leader>di',
        function()
          require('dap').step_into()
        end,
        desc = 'Step Into',
      },
      {
        '<leader>dj',
        function()
          require('dap').down()
        end,
        desc = 'Down',
      },
      {
        '<leader>dk',
        function()
          require('dap').up()
        end,
        desc = 'Up',
      },
      {
        '<leader>dl',
        function()
          require('dap').run_last()
        end,
        desc = 'Run Last',
      },
      {
        '<leader>do',
        function()
          require('dap').step_out()
        end,
        desc = 'Step Out',
      },
      {
        '<leader>dO',
        function()
          require('dap').step_over()
        end,
        desc = 'Step Over',
      },
      {
        '<leader>dP',
        function()
          require('dap').pause()
        end,
        desc = 'Pause',
      },
      {
        '<leader>dr',
        function()
          require('dap').repl.toggle()
        end,
        desc = 'Toggle REPL',
      },
      {
        '<leader>ds',
        function()
          require('dap').session()
        end,
        desc = 'Session',
      },
      {
        '<leader>dt',
        function()
          require('dap').terminate()
        end,
        desc = 'Terminate',
      },
      {
        '<leader>dw',
        function()
          require('dap.ui.widgets').hover()
        end,
        desc = 'Widgets',
      },
      {
        '<leader>du',
        function()
          require('dapui').toggle({})
        end,
        desc = 'Dap UI',
      },
      {
        '<leader>de',
        function()
          require('dapui').eval()
        end,
        desc = 'Eval',
        mode = { 'n', 'v' },
      },
      {
        '<leader>du',
        function()
          require('dapui').toggle({})
        end,
        desc = 'Dap UI',
      },
      {
        '<leader>de',
        function()
          require('dapui').eval()
        end,
        desc = 'Eval',
        mode = { 'n', 'v' },
      },
    },

    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      local dapvt = require('nvim-dap-virtual-text')
      local mason_dap = require('mason-nvim-dap')

      dapui.setup()

      mason_dap.setup({
        automatic_setup = true,
        ensure_installed = {
          'codelldb',
          'delve',
          'js-debug-adapter',
          'php-debug-adapter',
        },
      })

      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

      for name, sign in pairs(UserConfig.icons.dap) do
        sign = type(sign) == 'table' and sign or { sign }
        vim.fn.sign_define(
          'Dap' .. name,
          { text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3] }
        )
      end

      -- setup dap config by VsCode launch.json file
      local vscode = require('dap.ext.vscode')
      local json = require('plenary.json')
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      dapvt.setup({})

      for _, adapter in pairs({ 'node', 'chrome' }) do
        local pwa_adapter = 'pwa-' .. adapter

        -- Handle launch.json configurations
        -- which specify type as "node" or "chrome"
        -- Inspired by https://github.com/StevanFreeborn/nvim-config/blob/main/lua/plugins/debugging.lua#L111-L123

        -- Main adapter
        dap.adapters[pwa_adapter] = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'js-debug-adapter',
            args = { '${port}' },
          },
          enrich_config = function(config, on_config)
            -- Under the hood, always use the main adapter
            config.type = pwa_adapter
            on_config(config)
          end,
        }

        -- Dummy adapter, redirects to the main one
        dap.adapters[adapter] = dap.adapters[pwa_adapter]

        local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }
        local vscode = require('dap.ext.vscode')
        vscode.type_to_filetypes['node'] = js_filetypes
        vscode.type_to_filetypes['pwa-node'] = js_filetypes

        for _, language in ipairs(js_filetypes) do
          if not dap.configurations[language] then
            local runtimeExecutable = nil
            if language:find('typescript') then
              runtimeExecutable = vim.fn.executable('tsx') == 1 and 'tsx' or 'ts-node'
            end
            dap.configurations[language] = {
              {
                type = 'pwa-node',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',
                cwd = '${workspaceFolder}',
                sourceMaps = true,
                runtimeExecutable = runtimeExecutable,
                skipFiles = { '<node_internals>/**', 'node_modules/**' },
                resolveSourceMapLocations = {
                  '${workspaceFolder}/**',
                  '!**/node_modules/**',
                },
              },
              {
                type = 'pwa-node',
                request = 'attach',
                name = 'Attach',
                processId = require('dap.utils').pick_process,
                cwd = '${workspaceFolder}',
                sourceMaps = true,
                runtimeExecutable = runtimeExecutable,
                skipFiles = { '<node_internals>/**', 'node_modules/**' },
                resolveSourceMapLocations = {
                  '${workspaceFolder}/**',
                  '!**/node_modules/**',
                },
              },
            }
          end
        end
      end

      local php_dap_path = UserUtil.mason.get_package_install_path('php-debug-adapter')
      dap.adapters.php = {
        type = 'executable',
        command = 'node',
        args = { php_dap_path .. '/extension/out/phpDebug.js' },
      }

      require('dap-go').setup({
        delve = {
          path = function()
            return UserUtil.mason.get_package_bin_path('dlv')
          end,
        },
      })

      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = UserUtil.mason.get_package_bin_path('codelldb'),
          args = { '--port', '${port}' },
        },
      }
    end,
  },
}
