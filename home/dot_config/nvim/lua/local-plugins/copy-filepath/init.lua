local M = {}

M.setup = function()
  vim.api.nvim_create_user_command('CopyFilePathAbsolute', function()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
  end, { desc = 'Copy the absolute path of the current file to the clipboard' })

  vim.api.nvim_create_user_command('CopyFilePathRelative', function()
    local path = vim.fn.expand('%:.')
    vim.fn.setreg('+', path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
  end, { desc = 'Copy the relative path of the current file to the clipboard' })

  vim.keymap.set('n', '<leader>cpa', '<cmd>CopyFilePathAbsolute<CR>', { desc = "Copy file's absolute path" })
  vim.keymap.set('n', '<leader>cpr', '<cmd>CopyFilePathRelative<CR>', { desc = "Copy file's relative path" })
end

return M
