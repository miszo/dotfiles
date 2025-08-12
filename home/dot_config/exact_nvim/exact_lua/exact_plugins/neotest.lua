---@module 'lazy'
---@type LazySpec[]
return {
  {
    'nvim-neotest/neotest',
    commit = '3c81345c28cd639fcc02843ed3653be462f47024',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
      'nvim-neotest/neotest-go',
      'olimorris/neotest-rspec',
      'nvim-neotest/nvim-nio',
      'lawrence-laz/neotest-zig',
      'mfussenegger/nvim-dap',
    },
    -- opts = function(_, opts)
    --   opts.discovery = {
    --     enabled = false,
    --   }
    --   opts.adapters = {
    --     require('neotest-jest')({
    --       cwd = function()
    --         return vim.fn.getcwd()
    --       end,
    --       jest_test_discovery = true,
    --     }),
    --     require('neotest-vitest'),
    --     require('neotest-go')({
    --       dap_go_enabled = true,
    --     }),
    --     require('neotest-rspec'),
    --     require('neotest-zig'),
    --   }
    --   opts.status = {
    --     virtual_text = true,
    --   }
    --   opts.output = {
    --     open_on_run = true,
    --   }
    --   opts.quickfix = {
    --     open = function()
    --       require('trouble').open({ mode = 'quickfix', focus = false })
    --     end,
    --   }
    --
    --   return opts
    -- end,
    opts = {
      adapters = {
        ['neotest-jest'] = {
          cwd = function()
            return vim.fn.getcwd()
          end,
          jest_test_discovery = true,
        },
        ['neotest-vitest'] = {},
        ['neotest-go'] = {
          dap_go_enabled = true,
        },
        ['neotest-rspec'] = {},
        ['neotest-zig'] = {},
      },
      discovery = {
        enabled = false,
      },
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          require('trouble').open({ mode = 'quickfix', focus = false })
        end,
      },
    },
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace('neotest')
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)

      opts.consumers = opts.consumers or {}
      -- Refresh and auto close trouble after running tests
      ---@type neotest.Consumer
      opts.consumers.trouble = function(client)
        client.listeners.results = function(adapter_id, results, partial)
          if partial then
            return
          end
          local tree = assert(client:get_position(nil, { adapter = adapter_id }))

          local failed = 0
          for pos_id, result in pairs(results) do
            if result.status == 'failed' and tree:get_key(pos_id) then
              failed = failed + 1
            end
          end
          vim.schedule(function()
            local trouble = require('trouble')
            if trouble.is_open() then
              trouble.refresh()
              if failed == 0 then
                trouble.close()
              end
            end
          end)
        end
        return {}
      end

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == 'number' then
            if type(config) == 'string' then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == 'table' and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif adapter.adapter then
                adapter.adapter(config)
                adapter = adapter.adapter
              elseif meta and meta.__call then
                adapter = adapter(config)
              else
                error('Adapter ' .. name .. ' does not support setup')
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require('neotest').setup(opts)
    end,
    keys = {
      { '<leader>t', '', desc = '+test' },
      {
        '<leader>tt',
        function()
          require('neotest').run.run(vim.fn.expand('%'))
        end,
        desc = 'Run File (Neotest)',
      },
      {
        '<leader>tT',
        function()
          require('neotest').run.run(vim.uv.cwd())
        end,
        desc = 'Run All Test Files (Neotest)',
      },
      {
        '<leader>tr',
        function()
          require('neotest').run.run()
        end,
        desc = 'Run Nearest (Neotest)',
      },
      {
        '<leader>tl',
        function()
          require('neotest').run.run_last()
        end,
        desc = 'Run Last (Neotest)',
      },
      {
        '<leader>ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = 'Toggle Summary (Neotest)',
      },
      {
        '<leader>to',
        function()
          require('neotest').output.open({ enter = true, auto_close = true })
        end,
        desc = 'Show Output (Neotest)',
      },
      {
        '<leader>tO',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = 'Toggle Output Panel (Neotest)',
      },
      {
        '<leader>tS',
        function()
          require('neotest').run.stop()
        end,
        desc = 'Stop (Neotest)',
      },
      {
        '<leader>tw',
        function()
          require('neotest').watch.toggle(vim.fn.expand('%'))
        end,
        desc = 'Toggle Watch (Neotest)',
      },
    },
  },
  {
    'mfussenegger/nvim-dap',
    keys = {
      {
        '<leader>td',
        function()
          require('neotest').run.run({ strategy = 'dap' })
        end,
        desc = 'Debug Nearest',
      },
    },
  },
}
