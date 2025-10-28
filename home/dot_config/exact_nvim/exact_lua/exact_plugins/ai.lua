local copilot_model = 'gpt-4o'
local chat_adapter = 'copilot'
local chat_model = 'claude-sonnet-4'

local copilot_sonnet_strategy = {
  adapter = {
    name = chat_adapter,
    model = chat_model,
  },
  roles = {
    ---The header name for the LLM's messages
    ---@type string|fun(adapter: CodeCompanion.Adapter): string
    llm = function(adapter)
      return 'CodeCompanion (' .. adapter.formatted_name .. ', ' .. adapter.model.name .. ')'
    end,

    ---The header name for your messages
    ---@type string
    user = 'Miszo',
  },
}

---@module 'lazy'
---@type LazySpec[]
return {
  {
    'zbirenbaum/copilot.lua',
    dependencies = {
      {
        'copilotlsp-nvim/copilot-lsp',
        init = function()
          vim.g.copilot_nes_debounce = 500
        end,
      },
    },
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
    ---@type CopilotConfig
    opts = {
      copilot_model = copilot_model,
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
          accept = false, -- handled by completion plugin
          next = '<M-]>',
          prev = '<M-[>',
        },
      },
      nes = {
        enabled = true,
        keymap = {
          accept_and_goto = '<leader>p',
          accept = false,
          dismiss = '<Esc>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
    config = function(_, opts)
      require('copilot').setup(opts)
      UserUtil.cmp.actions.ai_accept = function()
        if require('copilot.suggestion').is_visible() then
          UserUtil.cmp.create_undo()
          require('copilot.suggestion').accept()
          return true
        end
      end
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
      },
      'MeanderingProgrammer/render-markdown.nvim',
      'j-hui/fidget.nvim',
      'ravitemer/codecompanion-history.nvim',
    },
    cmd = {
      'CodeCompanion',
      'CodeCompanionChat',
      'CodeCompanionActions',
      'CodeCompanionAdd',
    },
    opts = {
      strategies = {
        chat = vim.tbl_deep_extend('force', copilot_sonnet_strategy, {
          slash_commands = {
            ['buffer'] = {
              opts = {
                provider = 'snacks',
              },
            },
            ['terminal'] = {
              ---@param chat CodeCompanion.Chat
              callback = function(chat)
                Snacks.picker.buffers({
                  title = 'Terminals',
                  hidden = true,
                  actions = {
                    ---@param picker snacks.Picker
                    add_to_chat = function(picker)
                      picker:close()
                      local items = picker:selected({ fallback = true })
                      vim.iter(items):each(function(item)
                        local id = '<buf>' .. chat.context:make_id_from_buf(item.buf) .. '</buf>'
                        local lines = vim.api.nvim_buf_get_lines(item.buf, 0, -1, false)
                        local content = table.concat(lines, '\n')

                        chat:add_message({
                          role = 'user',
                          content = 'Terminal content from buffer '
                            .. item.buf
                            .. ' ('
                            .. item.file
                            .. '):\n'
                            .. content,
                        }, { reference = id, visible = false })

                        chat.context:add({
                          bufnr = item.buf,
                          id = id,
                          source = '',
                        })
                      end)
                    end,
                  },
                  win = { input = { keys = { ['<CR>'] = { 'add_to_chat', mode = { 'i', 'n' } } } } },
                  filter = {
                    filter = function(item)
                      return vim.bo[item.buf].buftype == 'terminal'
                    end,
                  },
                  main = { file = false },
                })
              end,
              description = 'Insert terminal output',
              opts = {
                provider = 'snacks',
              },
            },
          },
        }),
        inline = copilot_sonnet_strategy,
        cmd = copilot_sonnet_strategy,
      },
      display = {
        action_pallete = {
          provider = 'snacks',
        },
        diff = {
          enabled = true,
          close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          layout = 'vertical', -- vertical|horizontal split for default provider
          opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
          provider = 'default', -- default|mini_diff
        },
      },
      extensions = {
        history = {
          enabled = true,
          opts = {
            keymap = 'gh',
            continue_last_chat = false,
            delete_on_clearing_chat = false,
            picker = 'snacks',
            enable_logging = false,
            dir_to_save = vim.fn.stdpath('data') .. '/codecompanion-history',
            auto_save = true,
            auto_generate_title = true,
            title_generation_opts = {
              adapter = chat_adapter,
              model = chat_model,
            },
            picker_keymaps = {
              rename = { n = 'r', i = '<C-r>' },
              delete = { n = 'd', i = '<C-d>' },
              duplicate = { n = '<C-y>', i = '<C-y>' },
            },
          },
        },
      },
    },
    config = function(_, opts)
      require('codecompanion').setup(opts)
    end,
    keys = {
      { '<leader>a', '', desc = '+ai', mode = { 'n', 'v' } },
      { '<leader>aa', ':CodeCompanionChat<cr>', mode = { 'n', 'v' }, desc = 'Code Companion Chat' },
      { '<leader>ae', ':CodeCompanionChat Add<cr>', mode = { 'v' }, desc = 'Code Companion Add' },
      { '<leader>ap', ':CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'Code Companion Actions Palette' },
      { '<leader>ad', ':CodeCompanion /doc<cr>', mode = { 'v' }, desc = 'Code Companion Documentation' },
      { '<leader>ax', ':CodeCompanion /explain<cr>', mode = { 'v' }, desc = 'Code Companion Explain' },
      { '<leader>af', ':CodeCompanion /fix<cr>', mode = { 'v' }, desc = 'Code Companion Fix' },
      { '<leader>ah', ':CodeCompanionHistory<cr>', mode = { 'n' }, desc = 'Code Companion History' },
      { '<leader>ai', ':CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'Code Companion Inline Prompt' },
      { '<leader>al', ':CodeCompanion /lsp<cr>', mode = { 'n', 'v' }, desc = 'Code Companion LSP' },
      { '<leader>ar', ':CodeCompanion /optimize<cr>', mode = { 'v' }, desc = 'Code Companion Refactor' },
      { '<leader>as', ':CodeCompanion /spell<cr>', mode = { 'n', 'v' }, desc = 'Code Companion Spell' },
      { '<leader>at', ':CodeCompanion /tests<cr>', mode = { 'v' }, desc = 'Code Companion Generate Test' },
    },
  },
}
