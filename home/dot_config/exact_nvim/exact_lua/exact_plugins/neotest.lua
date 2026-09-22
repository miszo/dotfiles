local function is_js_project()
  local js_markers = { 'package.json', 'yarn.lock', 'package-lock.json', 'pnpm-lock.yaml' }
  return UserUtil.root.find(0, js_markers) ~= nil
end

local function has_bun_in_project()
  local bun_markers = { 'bun.lockb', 'bun.lock', 'bunfig.toml' }
  return UserUtil.root.find(0, bun_markers) ~= nil
end

local function is_go_project()
  local go_markers = { 'go.mod', 'go.sum' }
  return UserUtil.root.find(0, go_markers) ~= nil
end

local function find_jest_config(file_path)
  return UserUtil.root.find_marker(file_path, UserUtil.config_files.js_config_filenames('jest'))
end

local function find_vitest_config(file_path)
  return UserUtil.root.find_marker(
    file_path,
    vim.tbl_extend(
      'keep',
      UserUtil.config_files.js_config_filenames('vitest'),
      UserUtil.config_files.js_config_filenames('vite')
    )
  )
end

-- Neotest calls is_test_file in a fast event context, so no vim.fn here.
local function imports_node_test(file_path)
  local file = file_path and io.open(file_path, 'r')
  if not file then
    return false
  end

  local found = false
  for _ = 1, 20 do -- only the first 20 lines, imports live at the top
    local line = file:read('l')
    if not line then
      break
    end
    if line:match('^%s*import%s+.*%s+from%s+[\'"]node:test[\'"]') or line:match('require%([\'"]node:test[\'"]%)') then
      found = true
      break
    end
  end

  file:close()
  return found
end

-- The adapter's own matcher is name-based only (__tests__, *.test.*, *.spec.*),
-- which is every jest spec too, so also require a 'node:test' import.
local function setup_nodejs_adapter(adapter)
  adapter = adapter({ nodeCommand = 'node' })

  local matches_test_file_name = adapter.is_test_file

  adapter.is_test_file = function(file_path)
    return matches_test_file_name(file_path) and imports_node_test(file_path)
  end

  return adapter
end

-- Jest's own root is the nearest package.json, which in a monorepo gives one
-- adapter (so one result/watch/summary tree) per workspace package. Key it off
-- the lockfile instead, so the whole repo shares a single jest adapter.
local function find_js_root(file_path)
  return UserUtil.root.find_path(file_path, { 'yarn.lock', 'package-lock.json', 'pnpm-lock.yaml' })
end

local function setup_jest_adapter(adapter)
  adapter = adapter({
    cwd = find_js_root,
    jestConfigFile = find_jest_config,
    jest_test_discovery = true,
  })

  local original_root = adapter.root

  adapter.root = function(dir)
    return find_js_root(dir) or original_root(dir)
  end

  return adapter
end

local function setup_bun_adapter(adapter)
  local original_root = adapter.root

  adapter.root = function(dir)
    local bun_root = UserUtil.root.find_path(dir, { 'bunfig.toml', 'bun.lock', 'bun.lockb' })
    return bun_root or original_root(dir)
  end

  return adapter
end

local function parse_tsx_positions_in_main_process()
  local treesitter = require('neotest.lib').treesitter
  local original_parse_positions = treesitter.parse_positions

  treesitter.parse_positions = function(file_path, query, opts)
    if vim.endswith(file_path, '.tsx') and type(opts and opts.build_position) == 'string' then
      opts = vim.deepcopy(opts)
      opts.build_position = assert(loadstring('return ' .. opts.build_position))()
    end

    return original_parse_positions(file_path, query, opts)
  end
end

---@module 'lazy'
---@type LazySpec[]
return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      -- neotest dependencies
      'nvim-neotest/nvim-nio',
      -- adapters dependencies
      {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
      },
      -- adapters
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
      'arthur944/neotest-bun',
      'AkisArou/neotest-nodejs',
      'fredrikaverpil/neotest-golang',
      'olimorris/neotest-rspec',
      'lawrence-laz/neotest-zig',
      'mfussenegger/nvim-dap',
    },
    ---@type neotest.Config
    opts = {
      adapters = {
        ['neotest-rspec'] = {},
        ['neotest-zig'] = {},
      },
      discovery = {
        enabled = false,
      },
      floating = {
        border = vim.o.winborder,
      },
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          require('trouble').open({ mode = 'quickfix', focus = false })
        end,
      },
    },
    ---@param opts neotest.Config
    config = function(_, opts)
      parse_tsx_positions_in_main_process()

      local neotest_ns = vim.api.nvim_create_namespace('miszo/neotest')
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
        if is_js_project() then
          if has_bun_in_project() then
            opts.adapters['neotest-bun'] = setup_bun_adapter
          end
          opts.adapters['neotest-nodejs'] = setup_nodejs_adapter
          opts.adapters['neotest-jest'] = setup_jest_adapter
          -- Claims nothing unless the file's project depends on vitest
          opts.adapters['neotest-vitest'] = { vitestConfigFile = find_vitest_config }
        end

        -- Dynamically add golang adapter if go project detected
        if is_go_project() then
          opts.adapters['neotest-golang'] = {
            dap_go_enabled = true,
          }
        end

        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == 'number' then
            if type(config) == 'string' then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == 'function' then
              adapter = config(adapter)
            elseif type(config) == 'table' and not vim.tbl_isempty(config) then
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
        -- Neotest uses the first adapter whose is_test_file matches, and jest's
        -- matches any *.test.* file, so it has to be the last resort.
        table.sort(adapters, function(a, b)
          return b.name == 'neotest-jest' and a.name ~= 'neotest-jest'
        end)

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
