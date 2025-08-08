-- only run linters if a configuration file is found for the below linters
local linter_root_markers = {
  biome = { 'biome.json', 'biome.jsonc' },
  eslint_d = {
    'eslint.config.js',
    'eslint.config.mjs',
    'eslint.config.cjs',
    'eslint.config.ts',
    'eslint.config.mts',
    'eslint.config.cts',
    -- deprecated
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json',
  },
}

local biome_or_eslint = function()
  local has_biome_config = next(vim.fs.find(linter_root_markers['biome'], { upward = true }))
  local has_eslint_config = next(vim.fs.find(linter_root_markers['eslint_d'], { upward = true }))

  if has_biome_config then
    return { 'biome' }
  end

  if has_eslint_config then
    return { 'eslint_d' }
  end

  return {}
end

---@module "lazy"
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

      typescript = biome_or_eslint(),
      javascript = biome_or_eslint(),
      typescriptreact = biome_or_eslint(),
      javascriptreact = biome_or_eslint(),

      -- Lua
      -- lua = { 'luacheck' },

      -- Shell
      sh = { 'shellcheck' },
      bash = { 'shellcheck' },
      zsh = { 'shellcheck' },

      -- PHP/Laravel
      php = { 'pint' },
    }

    -- Auto-lint on save and text changes
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        if vim.opt_local.modifiable:get() then
          -- Only lint if linters are available for this filetype
          local linters = lint.linters_by_ft[vim.bo.filetype]
          if linters and #linters > 0 then
            lint.try_lint()
          end
        end
      end,
    })

    -- Manual linting command
    vim.keymap.set('n', '<leader>cl', function()
      lint.try_lint()
      vim.notify('Linting...', vim.log.levels.INFO, { title = 'nvim-lint' })
    end, { desc = 'Trigger linting for current file' })
  end,
}
