local M = {}

M.setup = function()
  vim.api.nvim_create_user_command('YankFilePathAbsolute', function()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    vim.notify(path)
  end, { desc = 'Copy the absolute path of the current file to the clipboard' })

  vim.api.nvim_create_user_command('YankFilePathRelative', function()
    local path = vim.fn.expand('%:.')
    vim.fn.setreg('+', path)
    vim.notify(path)
  end, { desc = 'Copy the relative path of the current file to the clipboard' })

  vim.keymap.set('n', '<leader>fY', '<cmd>YankFilePathAbsolute<CR>', { desc = "Yank file's absolute path" })
  vim.keymap.set('n', '<leader>fy', '<cmd>YankFilePathRelative<CR>', { desc = "Yank file's relative path" })
end

return M
