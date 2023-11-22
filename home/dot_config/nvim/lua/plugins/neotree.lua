return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    config = function(_, opts)
      opts.filesystem.commands = {

        -- Override delete to use trash instead of rm
        delete = function(state)
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
        -- over write default 'delete_visual' command to 'trash' x n.
        delete_visual = function(state, selected_nodes)
          local inputs = require('neo-tree.ui.inputs')

          -- get table items count
          function GetTableLen(tbl)
            local len = 0
            for n in pairs(tbl) do
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
      require('neo-tree').setup(opts)
    end,
  },
}
