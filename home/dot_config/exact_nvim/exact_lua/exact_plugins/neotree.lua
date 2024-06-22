return {
  {
    'vhyrro/luarocks.nvim',
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { 'magick' },
    },
  },
  {
    '3rd/image.nvim',
    dependencies = { 'luarocks.nvim' },
    config = function(_, opts)
      opts.integrations = opts.integrations or {}
      opts.integrations.markdown = opts.integrations.markdown or {}
      opts.integrations.markdown.only_render_image_at_cursor = true
      opts.hijack_file_patterns = opts.hijack_file_patterns or {}
      opts.hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif', '*.heic' }
      opts.window_overlap_clear_enabled = true
      require('image').setup(opts)
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      '3rd/image.nvim',
    },
    opts = function(_, opts)
      opts.filesystem = opts.filesystem or {}

      opts.filesystem.filtered_items = opts.filesystem.filtered_items or {}
      opts.filesystem.filtered_items.visible = true
      opts.filesystem.filtered_items.hide_dotfiles = false

      opts.filesystem.commands = opts.filesystem.commands or {}
      opts.filesystem.commands = {

        -- overwrite delete to use trash instead of rm
        delete = function(state)
          if vim.fn.executable('trash') == 0 then
            vim.api.nvim_echo({
              { '- Trash utility not installed. Make sure to install it first\n', nil },
              { '- In macOS run `brew install trash`\n', nil },
              { '- Or delete the `custom delete command` section in neo-tree', nil },
            }, false, {})
            return
          end
          local inputs = require('neo-tree.ui.inputs')
          local path = state.tree:get_node().path
          local msg = 'Are you sure you want to trash ' .. path
          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end

            vim.fn.system({ 'trash', vim.fn.fnameescape(path) })
            require('neo-tree.sources.manager').refresh(state.name)
          end)
        end,
        -- overwrite default 'delete_visual' command to 'trash' x n.
        delete_visual = function(state, selected_nodes)
          if vim.fn.executable('trash') == 0 then
            vim.api.nvim_echo({
              { '- Trash utility not installed. Make sure to install it first\n', nil },
              { '- In macOS run `brew install trash`\n', nil },
              { '- Or delete the `custom delete command` section in neo-tree', nil },
            }, false, {})
            return
          end
          local inputs = require('neo-tree.ui.inputs')

          -- get table items count
          function GetTableLen(tbl)
            local len = 0
            for _ in pairs(tbl) do
              len = len + 1
            end
            return len
          end

          local count = GetTableLen(selected_nodes)
          local msg = 'Are you sure you want to trash ' .. count .. ' files ?'
          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end
            for _, node in ipairs(selected_nodes) do
              vim.fn.system({ 'trash', vim.fn.fnameescape(node.path) })
            end
            require('neo-tree.sources.manager').refresh(state.name)
          end)
        end,
      }

      opts.window = opts.window or {}
      opts.window.mappings = opts.window.mappings or {}

      vim.tbl_extend('force', opts.window.mappings, {
        ['P'] = { 'toggle_preview', config = { use_float = false, use_image_nvim = true } },
      })

      opts.window.position = 'right'
    end,
  },
}
