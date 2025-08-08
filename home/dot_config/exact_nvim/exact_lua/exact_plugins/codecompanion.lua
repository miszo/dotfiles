---@module 'lazy'
---@type LazySpec[]
return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'MeanderingProgrammer/render-markdown.nvim',
      'j-hui/fidget.nvim',
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'copilot',
          model = 'claude-sonnet-4',
          roles = {
            ---The header name for the LLM's messages
            ---@type string|fun(adapter: CodeCompanion.Adapter): string
            llm = function(adapter)
              return 'CodeCompanion (' .. adapter.formatted_name .. ')'
            end,

            ---The header name for your messages
            ---@type string
            user = 'Miszo',
          },
        },
        inline = {
          adapter = 'copilot',
          model = 'gpt-4.1',
        },
        cmd = {
          adapter = 'copilot',
          model = 'claude-sonnet-4',
        },
      },
      display = {
        action_pallete = {
          provider = 'snacks',
        },
      },
    },
    config = function(_, opts)
      require('codecompanion').setup(opts)

      local progress = require('fidget.progress')
      local handles = {}
      local group = vim.api.nvim_create_augroup('CodeCompanionFidget', {})

      vim.api.nvim_create_autocmd('User', {
        pattern = 'CodeCompanionRequestStarted',
        group = group,
        callback = function(e)
          handles[e.data.id] = progress.handle.create({
            title = 'CodeCompanion',
            message = 'Thinking...',
            lsp_client = { name = e.data.adapter.formatted_name },
          })
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'CodeCompanionRequestFinished',
        group = group,
        callback = function(e)
          local h = handles[e.data.id]
          if h then
            h.message = e.data.status == 'success' and 'Done' or 'Failed'
            h:finish()
            handles[e.data.id] = nil
          end
        end,
      })

      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'codecompanion',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })
    end,
    keys = {
      { '<leader>a', '', desc = '+ai', mode = { 'n', 'v' } },
      {
        '<leader>aa',
        function()
          return require('codecompanion').toggle()
        end,
        desc = 'Toggle (CodeCompanion)',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ap',
        function()
          return require('codecompanion').actions({})
        end,
        desc = 'Chat (CodeCompanion)',
      },
      {
        'q',
        function()
          return require('codecompanion').close_last_chat()
        end,
        desc = 'Chat (CodeCompanion)',
        mode = { 'n', 'v' },
      },
    },
  },
}
