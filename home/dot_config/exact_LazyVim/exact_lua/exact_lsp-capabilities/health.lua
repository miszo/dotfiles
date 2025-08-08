local M = {}

M.check = function()
  vim.health.start('LSP Capabilities Check')

  -- Get all active LSP clients instead of buffer-specific ones
  local clients = vim.lsp.get_clients()

  if #clients == 0 then
    vim.health.error('No LSP clients running', {
      'Make sure you have LSP servers configured and running',
      'Try opening a file that should have LSP support first',
    })
    return
  end

  vim.health.ok(string.format('Found %d active LSP client(s)', #clients))

  for _, client in ipairs(clients) do
    vim.health.start('Client: ' .. client.name)

    local caps = client.server_capabilities
    if not caps then
      vim.health.error('No capabilities found')
      goto continue
    end

    -- Show attached buffers for this client
    local attached_buffers = {}
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.lsp.buf_is_attached(bufnr, client.id) then
        local buf_name = vim.api.nvim_buf_get_name(bufnr)
        if buf_name ~= '' then
          table.insert(attached_buffers, vim.fn.fnamemodify(buf_name, ':t'))
        end
      end
    end

    if #attached_buffers > 0 then
      vim.health.ok('Attached to: ' .. table.concat(attached_buffers, ', '))
    else
      vim.health.warn('Not attached to any buffers')
    end

    -- Your capability checks here...
    local capability_list = {
      { 'Completion', caps.completionProvider },
      { 'Hover', caps.hoverProvider },
      { 'Signature Help', caps.signatureHelpProvider },
      { 'Go to Definition', caps.definitionProvider },
      { 'Go to Declaration', caps.declarationProvider },
      { 'Go to Implementation', caps.implementationProvider },
      { 'Go to Type Definition', caps.typeDefinitionProvider },
      { 'Find References', caps.referencesProvider },
      { 'Document Highlight', caps.documentHighlightProvider },
      { 'Document Symbol', caps.documentSymbolProvider },
      { 'Workspace Symbol', caps.workspaceSymbolProvider },
      { 'Code Action', caps.codeActionProvider },
      { 'Code Lens', caps.codeLensProvider },
      { 'Document Formatting', caps.documentFormattingProvider },
      { 'Document Range Formatting', caps.documentRangeFormattingProvider },
      { 'Rename', caps.renameProvider },
      { 'Folding Range', caps.foldingRangeProvider },
      { 'Selection Range', caps.selectionRangeProvider },
    }

    for _, cap in ipairs(capability_list) do
      if cap[2] then
        vim.health.ok(cap[1])
      else
        vim.health.info('⚠️' .. cap[1] .. ' (not supported)')
      end
    end

    ::continue::
  end
end

return M
