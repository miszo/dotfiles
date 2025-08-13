-- only run linters if a configuration file is found for the below linters
local linter_root_markers = {
  biome = { 'biome.json', 'biome.jsonc' },
}

local function debounce(ms, fn)
  local timer = vim.uv.new_timer()

  if not timer then
    -- If timer creation fails, fallback to immediate execution
    vim.notify('Failed to create timer, executing function immediately.', vim.log.levels.WARN, { title = 'nvim-lint' })
    return function(...)
      local argv = { ... }
      fn(unpack(argv))
    end
  end
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

local biome_or_eslint = function()
  local has_biome_config = next(vim.fs.find(linter_root_markers['biome'], { upward = true }))

  if has_biome_config then
    return { 'biomejs' }
  end

  return {}
end

local ft_with_js_linter = {
  'astro',
  'svelte',
  'graphql',
  'javascriptreact',
  'typescriptreact',
  'vue',
  'javascript',
  'json',
  'jsonc',
  'typescript',
}

---@module 'lazy'
---@type LazySpec[]
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')

    -- Configure custom linters using Mason-managed tools
    local mason_bin_dir = vim.fn.stdpath('data') .. '/mason/bin'

    -- Customize golangcilint to ignore exit codes (golangci-lint exits with code 1-3 when issues are found)
    local golangcilint = require('lint').linters.golangcilint
    golangcilint.ignore_exitcode = true

    -- Configure Laravel Pint for linting (using --test mode)
    local pint_cmd = vim.fn.executable(mason_bin_dir .. '/pint') == 1 and mason_bin_dir .. '/pint' or 'pint'

    lint.linters.pint = {
      cmd = pint_cmd,
      stdin = false,
      args = { '--test' },
      stream = 'stderr', -- Pint outputs diagnostics to stderr
      ignore_exitcode = true,
      parser = function(output)
        local diagnostics = {}

        if not output or output == '' then
          return diagnostics
        end

        -- Check if output contains style issues
        -- Pint outputs human-readable format by default when there are issues
        if string.find(output, 'FAIL') or string.find(output, 'differs') then
          table.insert(diagnostics, {
            lnum = 0,
            col = 0,
            message = 'Code style issues found - run formatter to fix',
            severity = vim.diagnostic.severity.WARN,
            source = 'pint',
          })
        end

        return diagnostics
      end,
    }

    -- Configure linters by filetype (using Mason-managed tools)
    lint.linters_by_ft = {
      -- Go
      go = { 'golangcilint' },

      -- Lua
      -- lua = { 'luacheck' },

      -- Shell
      sh = { 'shellcheck' },
      bash = { 'shellcheck' },
      zsh = { 'shellcheck' },

      -- PHP/Laravel
      php = { 'pint' },
      sql = { 'sqlfluff' },
    }

    for _, ft in ipairs(ft_with_js_linter) do
      lint.linters_by_ft[ft] = biome_or_eslint()
    end

    local function try_lint()
      if vim.opt_local.modifiable:get() then
        -- Only lint if linters are available for this filetype
        local linters = lint.linters_by_ft[vim.bo.filetype]
        if linters and #linters > 0 then
          lint.try_lint()
        end
      end
    end

    -- Auto-lint on save and text changes
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = debounce(100, try_lint),
    })

    -- Manual linting command
    vim.keymap.set('n', '<leader>cl', function()
      lint.try_lint()
      vim.notify('Linting...', vim.log.levels.INFO, { title = 'nvim-lint' })
    end, { desc = 'Trigger linting for current file' })
  end,
}
