local copilot_model = 'gpt-4o'

---@module 'lazy'
---@type LazySpec[]
return {
  -- GitHub Copilot - Inline suggestions and LSP server
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
      -- NES UI is handled by sidekick.nvim for better visualization
      -- copilot.lua keeps the LSP running (required by sidekick)
      nes = {
        enabled = false, -- sidekick.nvim handles NES UI
        keymap = {
          accept_and_goto = false, -- use sidekick's Tab-based navigation
          accept = false,
          dismiss = false,
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
      -- Register copilot suggestion accept action for blink.cmp
      UserUtil.cmp.actions.ai_accept = function()
        if require('copilot.suggestion').is_visible() then
          UserUtil.cmp.create_undo()
          require('copilot.suggestion').accept()
          return true
        end
      end
    end,
  },

  -- Sidekick - NES visualization and AI CLI integration
  {
    'folke/sidekick.nvim',
    dependencies = { 'zbirenbaum/copilot.lua' }, -- needs copilot LSP
    opts = {
      -- Next Edit Suggestions configuration
      nes = {
        enabled = true,
        debounce = 100,
        trigger = {
          events = { 'ModeChanged i:n', 'TextChanged', 'User SidekickNesDone' },
        },
        clear = {
          events = { 'TextChangedI', 'InsertEnter' },
          esc = true,
        },
        diff = {
          inline = 'words', -- word-level inline diffs
        },
      },

      -- Signs configuration
      signs = {
        enabled = true,
        icon = ' ',
      },

      -- Jump configuration
      jump = {
        jumplist = true, -- add entries to jumplist when navigating
      },

      -- CLI Tools Integration
      cli = {
        watch = true, -- auto-reload files modified by AI tools

        -- Window configuration for AI CLI tools
        win = {
          layout = 'right', -- right split for OpenCode terminal
          wo = {},
          bo = {},

          -- Split configuration (for right layout)
          split = {
            width = 80, -- 80 columns for the right split
            height = 0, -- use default height
          },

          -- Terminal keymaps
          keys = {
            buffers = { '<c-b>', 'buffers', mode = 'nt', desc = 'open buffer picker' },
            files = { '<c-f>', 'files', mode = 'nt', desc = 'open file picker' },
            hide_n = { 'q', 'hide', mode = 'n', desc = 'hide the terminal window' },
            hide_ctrl_q = { '<c-q>', 'hide', mode = 'n', desc = 'hide the terminal window' },
            hide_ctrl_dot = { '<c-.>', 'hide', mode = 'nt', desc = 'hide the terminal window' },
            hide_ctrl_z = { '<c-z>', 'hide', mode = 'nt', desc = 'hide the terminal window' },
            prompt = { '<c-p>', 'prompt', mode = 't', desc = 'insert prompt or context' },
            stopinsert = { '<c-q>', 'stopinsert', mode = 't', desc = 'enter normal mode' },
            -- Navigate windows in terminal mode
            nav_left = { '<c-h>', 'nav_left', expr = true, desc = 'navigate to the left window' },
            nav_down = { '<c-j>', 'nav_down', expr = true, desc = 'navigate to the below window' },
            nav_up = { '<c-k>', 'nav_up', expr = true, desc = 'navigate to the above window' },
            nav_right = { '<c-l>', 'nav_right', expr = true, desc = 'navigate to the right window' },
          },
        },
        -- Tmux multiplexer for persistent sessions
        mux = {
          backend = 'tmux',
          enabled = true,
          create = 'terminal', -- create sessions in Neovim terminal
        },
        -- AI CLI Tools configuration
        tools = {
          claude = { cmd = { 'claude' } },
          codex = { cmd = { 'codex', '--enable', 'web_search_request' } },
          copilot = { cmd = { 'copilot', '--banner' } },
          cursor = { cmd = { 'cursor-agent' } },
          gemini = { cmd = { 'gemini' } },
          opencode = {
            cmd = { 'opencode' },
            -- Workaround for OpenCode issue #445
            env = { OPENCODE_THEME = 'system' },
          },
        },

        -- Prompt library for common tasks
        prompts = {
          changes = 'Can you review my changes?',
          diagnostics = 'Can you help me fix the diagnostics in {file}?\n{diagnostics}',
          diagnostics_all = 'Can you help me fix these diagnostics?\n{diagnostics_all}',
          document = 'Add documentation to {function|line}',
          explain = 'Explain {this}',
          fix = 'Can you fix {this}?',
          optimize = 'How can {this} be optimized?',
          review = 'Can you review {file} for any issues or improvements?',
          tests = 'Can you write tests for {this}?',
          -- Simple context prompts
          buffers = '{buffers}',
          file = '{file}',
          line = '{line}',
          position = '{position}',
          quickfix = '{quickfix}',
          selection = '{selection}',
          ['function'] = '{function}',
          class = '{class}',
        },

        -- Preferred picker for file selection
        picker = 'snacks', -- use Snacks.nvim picker
      },

      -- Copilot status tracking
      copilot = {
        status = {
          enabled = true,
          level = vim.log.levels.WARN,
        },
      },

      -- UI configuration
      ui = {
        icons = UserConfig.icons.ai_sidekick,
      },
    },

    -- Keybindings for sidekick
    keys = {
      -- Tab navigation for Next Edit Suggestions
      {
        '<tab>',
        function()
          -- Jump to or apply next edit suggestion
          if not require('sidekick').nes_jump_or_apply() then
            return '<Tab>' -- fallback to normal tab
          end
        end,
        expr = true,
        desc = 'Sidekick: Goto/Apply Next Edit Suggestion',
        mode = { 'n' },
      },

      -- AI commands prefix: <leader>a
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle({ name = 'opencode', focus = true })
        end,
        desc = 'Sidekick: Toggle CLI',
      },

      {
        '<leader>as',
        function()
          require('sidekick.cli').select()
        end,
        desc = 'Sidekick: Select CLI Tool',
      },

      {
        '<leader>ad',
        function()
          require('sidekick.cli').close()
        end,
        desc = 'Sidekick: Close/Detach CLI Session',
      },

      {
        '<leader>at',
        function()
          local util = require('lualine.components.sidekick.util')
          util.set_user_action(true)
          require('sidekick.cli').send({ msg = '{this}' })
          vim.defer_fn(function()
            util.set_user_action(false)
          end, 2000)
        end,
        mode = { 'x', 'n' },
        desc = 'Sidekick: Send This (context)',
      },

      {
        '<leader>af',
        function()
          local util = require('lualine.components.sidekick.util')
          util.set_user_action(true)
          require('sidekick.cli').send({ msg = '{file}' })
          vim.defer_fn(function()
            util.set_user_action(false)
          end, 2000)
        end,
        desc = 'Sidekick: Send File',
      },

      {
        '<leader>av',
        function()
          local util = require('lualine.components.sidekick.util')
          util.set_user_action(true)
          require('sidekick.cli').send({ msg = '{selection}' })
          vim.defer_fn(function()
            util.set_user_action(false)
          end, 2000)
        end,
        mode = { 'x' },
        desc = 'Sidekick: Send Visual Selection',
      },

      {
        '<leader>ap',
        function()
          local util = require('lualine.components.sidekick.util')
          util.set_user_action(true)
          require('sidekick.cli').prompt()
          vim.defer_fn(function()
            util.set_user_action(false)
          end, 2000)
        end,
        mode = { 'n', 'x' },
        desc = 'Sidekick: Select Prompt',
      },
    },
  },
}
