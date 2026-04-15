local M = {}

local DEFAULT_APPS_DIR = 'apps'
local DEFAULT_LIBS_DIR = 'libs'

--- Read and parse a JSON file, returning nil on failure.
---@param path string
---@return table?
local function read_json(path)
  if vim.fn.filereadable(path) == 0 then
    return nil
  end
  local ok, result = pcall(vim.fn.json_decode, table.concat(vim.fn.readfile(path), '\n'))
  return ok and result or nil
end

--- Determine the import module specifier for the given buffer in an Nx workspace.
--- Files inside apps/ or libs/ get "project-relative"; workspace-level files get "non-relative".
--- .vscode/settings.json overrides are honored when present.
---@param client vim.lsp.Client
---@param bufnr number
function M.adjust_config_for_nx(client, bufnr)
  local nx_root = UserUtil.root.find(bufnr, { 'nx.json' })
  if not nx_root then
    return
  end

  local nx_config = read_json(vim.fs.joinpath(nx_root, 'nx.json'))
  local layout = nx_config and nx_config.workspaceLayout or {}
  local apps_dir = vim.fs.joinpath(nx_root, layout.appsDir or DEFAULT_APPS_DIR)
  local libs_dir = vim.fs.joinpath(nx_root, layout.libsDir or DEFAULT_LIBS_DIR)

  local buf_path = vim.api.nvim_buf_get_name(bufnr)
  local is_app_or_lib = vim.startswith(buf_path, apps_dir) or vim.startswith(buf_path, libs_dir)

  -- Default specifiers
  local specifier = is_app_or_lib and 'project-relative' or 'non-relative'

  -- Honor .vscode/settings.json override if present
  local vscode_root = UserUtil.root.find(bufnr, { '.vscode' })
  if vscode_root and vim.startswith(buf_path, vscode_root) then
    local vscode_settings = read_json(vim.fs.joinpath(vscode_root, '.vscode', 'settings.json'))
    if vscode_settings then
      local override = vscode_settings['typescript.preferences.importModuleSpecifier']
        or vscode_settings['javascript.preferences.importModuleSpecifier']
      if override then
        specifier = override
      end
    end
  end

  -- Skip if already set correctly
  local current = client.config.settings.typescript
    and client.config.settings.typescript.preferences
    and client.config.settings.typescript.preferences.importModuleSpecifier
  if current == specifier then
    return
  end

  client.config.settings = vim.tbl_deep_extend('force', client.config.settings or {}, {
    typescript = { preferences = { importModuleSpecifier = specifier } },
    javascript = { preferences = { importModuleSpecifier = specifier } },
  })

  client:notify(vim.lsp.protocol.Methods.workspace_didChangeConfiguration, { settings = client.config.settings })
end

return M
