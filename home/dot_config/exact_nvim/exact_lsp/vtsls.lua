local ts_preferences = {
  importModuleSpecifier = 'non-relative',
  preferTypeOnlyAutoImports = true,
  quoteStyle = 'single',
  useAliasesForRenames = false,
}

local inlayHints = {
  enumMemberValues = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  parameterNames = { enabled = 'literals' },
  parameterTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  variableTypes = { enabled = false },
}

local updateImportsOnFileMove = { enabled = 'always' }

local suggest = {
  completeFunctionCalls = true,
}

--- Set 8GB for tsserver memory limit
local max_ts_server_memory = 8192

---@type vim.lsp.Config
return {
  cmd = { 'vtsls', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  init_options = {
    plugins = {
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
      },
    },
  },
  settings = {
    complete_function_calls = false,
    typescript = {
      updateImportsOnFileMove = updateImportsOnFileMove,
      suggest = suggest,
      inlayHints = inlayHints,
      preferences = ts_preferences,
      tsserver = {
        maxTsServerMemory = max_ts_server_memory,
      },
    },
    javascript = {
      updateImportsOnFileMove = updateImportsOnFileMove,
      suggest = suggest,
      inlayHints = inlayHints,
      preferences = ts_preferences,
    },
    vtsls = {
      autoUseWorkspaceTsdk = true,
      enableMoveToFileCodeAction = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
  },
  root_dir = function(bufnr, on_dir)
    -- The project root is where the LSP can be started from
    -- As stated in the documentation above, this LSP supports monorepos and simple projects.
    -- We select then from the project root, which is identified by the presence of a package
    -- manager lock file.
    local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', { '.git' } }
    -- We fallback to the current working directory if no project root is found
    local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

    on_dir(project_root)
  end,
}
