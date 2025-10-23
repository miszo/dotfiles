local M = {}

local fallback_apps_dir = 'apps'
local fallback_libs_dir = 'libs'
local workspace_import_module_specifier = 'non-relative'
local fallback_library_import_module_specifier = 'project-relative'

local function get_nx_root(bufnr)
  return vim.fs.root(bufnr, { 'nx.json' })
end

local function get_nx_config(bufnr)
  local root = get_nx_root(bufnr)

  if not root then
    return nil
  end

  local nx_json_path = vim.fs.joinpath(root, 'nx.json')

  if vim.fn.filereadable(nx_json_path) == 0 then
    return nil
  end

  local nx_config = vim.fn.json_decode((table.concat(vim.fn.readfile(nx_json_path), '\n')))

  return nx_config
end

local function get_codesettings_root(bufnr)
  return vim.fs.root(bufnr, { '.vscode' })
end

local function get_codesettings_config(bufnr)
  local root = get_codesettings_root(bufnr)

  if not root then
    return nil
  end

  local vscode_settings_path = vim.fs.joinpath(root, '.vscode', 'settings.json')

  if vim.fn.filereadable(vscode_settings_path) == 0 then
    return nil
  end

  local settings_config = vim.fn.json_decode((table.concat(vim.fn.readfile(vscode_settings_path), '\n')))

  return settings_config
end

function M.adjust_config_for_nx(client, bufnr)
  if client.name ~= 'vtsls' then
    return
  end

  local nx_config = get_nx_config(bufnr)

  if not nx_config or not nx_config.workspaceLayout then
    return
  end

  local buf_path = vim.api.nvim_buf_get_name(bufnr)
  local code_root_path = get_codesettings_root(bufnr)
  local root_path = get_nx_root(bufnr)

  -- join root path if code root path is available
  local apps_dir = vim.fs.joinpath(root_path, nx_config.workspaceLayout.appsDir or fallback_apps_dir)
  local libs_dir = vim.fs.joinpath(root_path, nx_config.workspaceLayout.libsDir or fallback_libs_dir)
  local code_settings = get_codesettings_config(bufnr)

  local is_app_or_lib = vim.startswith(buf_path, apps_dir) or vim.startswith(buf_path, libs_dir)

  local current_import_module_specifier = client.config.settings.typescript.preferences.importModuleSpecifier
    or client.config.settings.javascript.preferences.importModuleSpecifier
  local library_import_module_specifier = fallback_library_import_module_specifier
  local library_import_module_specifier_code_setting = code_settings
    and (
      code_settings['typescript.preferences.importModuleSpecifier']
      or code_settings['javascript.preferences.importModuleSpecifier']
    )
  local workspace_import_module_specifier_code_setting = code_settings
    and (
      code_settings['typescript.preferences.importModuleSpecifier']
      or code_settings['javascript.preferences.importModuleSpecifier']
    )

  if
    is_app_or_lib
    and (
      current_import_module_specifier == library_import_module_specifier
      or current_import_module_specifier == library_import_module_specifier_code_setting
    )
  then
    return
  end

  if
    not is_app_or_lib
    and (
      current_import_module_specifier == workspace_import_module_specifier
      or current_import_module_specifier == workspace_import_module_specifier_code_setting
    )
  then
    return
  end

  if is_app_or_lib and vim.startswith(buf_path, code_root_path) and library_import_module_specifier_code_setting then
    library_import_module_specifier = library_import_module_specifier_code_setting
  end

  if
    not is_app_or_lib
    and vim.startswith(buf_path, code_root_path)
    and workspace_import_module_specifier_code_setting
  then
    workspace_import_module_specifier = workspace_import_module_specifier_code_setting
  end

  if is_app_or_lib then
    client.config.settings = vim.tbl_deep_extend('force', client.config.settings or {}, {
      typescript = {
        preferences = {
          importModuleSpecifier = library_import_module_specifier,
        },
      },
      javascript = {
        preferences = {
          importModuleSpecifier = library_import_module_specifier,
        },
      },
    })
  else
    client.config.settings = vim.tbl_deep_extend('force', client.config.settings or {}, {
      typescript = {
        preferences = {
          importModuleSpecifier = workspace_import_module_specifier,
        },
      },
      javascript = {
        preferences = {
          importModuleSpecifier = workspace_import_module_specifier,
        },
      },
    })
  end

  client.notify(vim.lsp.protocol.Methods.workspace_didChangeConfiguration, { settings = client.config.settings })
end

return M
