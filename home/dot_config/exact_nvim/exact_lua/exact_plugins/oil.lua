---@module 'lazy'
---@type LazySpec[]
return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = { 'nvim-mini/mini.icons' },
    config = function()
      local oil = require('oil')
      local details_visible = false

      oil.setup({
        default_file_explorer = true,
        columns = {
          'icon',
        },
        keymaps_help = {
          border = 'rounded',
        },
        delete_to_trash = true,
        watch_for_changes = true,
        use_default_keymaps = false,
        lsp_file_methods = {
          -- Enable or disable LSP file operations
          enabled = true,
          -- Time to wait for LSP file operations to complete before skipping
          timeout_ms = 3000,
          -- Set to true to autosave buffers that are updated with LSP willRenameFiles
          -- Set to "unmodified" to only save unmodified buffers
          autosave_changes = 'unmodified',
        },
        skip_confirm_for_simple_edits = true,
        prompt_save_on_select_new_entry = true,
        keymaps = {
          ['g?'] = { 'actions.show_help', mode = 'n' },
          ['<CR>'] = 'actions.select',
          ['<leader>\\'] = { 'actions.select', opts = { vertical = true } },
          ['<leader>-'] = { 'actions.select', opts = { horizontal = true } },
          ['<C-p>'] = 'actions.preview',
          ['<C-f'] = 'action.preview_scroll_down',
          ['<C-b'] = 'action.preview_scroll_up',
          ['<C-c>'] = { 'actions.close', mode = 'n' },
          ['q'] = { 'actions.close', mode = 'n' },
          ['<leader>u'] = 'actions.refresh',
          ['-'] = { 'actions.parent', mode = 'n' },
          ['<BS>'] = { 'actions.parent', mode = 'n' },
          ['_'] = { 'actions.open_cwd', mode = 'n' },
          ['`'] = { 'actions.cd', mode = 'n' },
          ['gs'] = { 'actions.change_sort', mode = 'n' },
          ['gx'] = 'actions.open_external',
          ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
          ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
          ['gd'] = {
            desc = 'Toggle file detail view',
            callback = function()
              details_visible = not details_visible
              if details_visible then
                require('oil').set_columns({ 'permissions', 'size', 'mtime', 'icon' })
              else
                require('oil').set_columns({ 'icon' })
              end
            end,
          },
        },
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name, _)
            local m = name:match('^%.')
            return m ~= nil
          end,
          is_always_hidden = function(name, _)
            return name == '.DS_Store' or name == 'thumbs.db' or name == '..'
          end,
        },
      })
      vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })

      -- Use the FreeDesktop trash adapter for trash functionality
      package.loaded['oil.adapters.trash'] = require('oil.adapters.trash.freedesktop')
    end,
  },
}
