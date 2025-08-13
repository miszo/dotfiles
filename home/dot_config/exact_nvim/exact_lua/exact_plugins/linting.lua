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
    -- Customize golangcilint to ignore exit codes (golangci-lint exits with code 1-3 when issues are found)
    local golangcilint = require('lint').linters.golangcilint
    golangcilint.ignore_exitcode = true

    -- Configure Laravel Pint for linting (using --test mode)
    local pint_mason_path = UserUtil.mason.get_package_install_path('pint')
    local pint_cmd = vim.fn.executable(pint_mason_path) == 1 and pint_mason_path or 'pint'

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

      -- SQL
      sql = { 'sqlfluff' },
    }

    -- JavaScript/TypeScript linters - make sure we don't any linters that conflict with the LSP
    for _, ft in ipairs(ft_with_js_linter) do
      lint.linters_by_ft[ft] = {}
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

    -- print linters available for current filetype
    vim.keymap.set('n', '<leader>cL', function()
      local linters = lint.linters_by_ft[vim.bo.filetype]
      if linters and #linters > 0 then
        vim.notify('Available linters: ' .. table.concat(linters, ', '), vim.log.levels.INFO, { title = 'nvim-lint' })
      else
        vim.notify('No linters available for this filetype', vim.log.levels.WARN, { title = 'nvim-lint' })
      end
    end, { desc = 'Show available linters for current filetype' })
  end,
}
