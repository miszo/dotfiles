local update_imports_on_file_move = { enabled = 'always' }

local ts_preferences = {
  includeCompletionsForModuleExports = true,
  includeCompletionsForImportStatements = true,
  importModuleSpecifier = 'non-relative',
  preferTypeOnlyAutoImports = true,
  quoteStyle = 'single',
  useAliasesForRenames = false,
  updateImportsOnFileMove = update_imports_on_file_move,
}

local inlay_hints = {
  enumMemberValues = { enabled = true },
  functionLikeReturnTypes = { enabled = false },
  parameterNames = { enabled = 'literals', suppressWhenArgumentMatchesName = true },
  parameterTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  variableTypes = { enabled = false },
}

local suggest = {
  completeFunctionCalls = false,
}

---@type vim.lsp.Config
return {
  cmd = { 'tsgo', '--lsp', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'vue',
    'astro',
    'svelte',
  },
  settings = {
    typescript = {
      updateImportsOnFileMove = update_imports_on_file_move,
      suggest = suggest,
      inlayHints = inlay_hints,
      preferences = ts_preferences,
      tsserver = {
        globalPlugins = {
          {
            enableForWorkspaceTypeScriptVersions = true,
            location = vim.fs.normalize(
              vim.fs.joinpath(
                vim.fn.stdpath('data'),
                '/mason/packages/angular-language-server/node_modules/@angular/language-server'
              )
            ),
            name = '@angular/language-server',
          },
          {
            enableForWorkspaceTypeScriptVersions = true,
            location = vim.fs.normalize(
              vim.fs.joinpath(
                vim.fn.stdpath('data'),
                'mason/packages/astro-language-server/node_modules/@astrojs/ts-plugin'
              )
            ),
            name = '@astrojs/ts-plugin',
          },
          {
            enableForWorkspaceTypeScriptVersions = true,
            location = vim.fs.normalize(
              vim.fs.joinpath(
                vim.fn.stdpath('data'),
                'mason/packages/svelte-language-server/node_modules/typescript-svelte-plugin'
              )
            ),
            name = 'typescript-svelte-plugin',
          },
          {
            enableForWorkspaceTypeScriptVersions = true,
            location = vim.fs.normalize(
              vim.fs.joinpath(
                vim.fn.stdpath('data'),
                '/mason/packages/vue-language-server/node_modules/@vue/language-server'
              )
            ),
            name = '@vue/language-server',
            languages = { 'vue' },
            configNamespace = 'typescript',
          },
        },
      },
    },
    javascript = {
      updateImportsOnFileMove = update_imports_on_file_move,
      suggest = suggest,
      inlayHints = inlay_hints,
      preferences = ts_preferences,
    },
  },
  root_dir = function(bufnr, on_dir)
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', { '.git' } }
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    on_dir(project_root)
  end,
}
