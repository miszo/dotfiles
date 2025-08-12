---@module 'lazy'
---@type LazySpec[]
return {
  { 'L3MON4D3/LuaSnip', keys = {} },
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'kristijanhusak/vim-dadbod-completion',
    },
    version = '*',
    config = function()
      require('blink.cmp').setup({
        snippets = { preset = 'luasnip' },
        signature = { enabled = true },
        appearance = {
          use_nvim_cmp_as_default = false,
          nerd_font_variant = 'normal',
        },
        sources = {
          default = { 'dadbod', 'laravel', 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
          per_filetype = {
            codecompanion = { 'codecompanion' },
            sql = { 'snippets', 'dadbod', 'dbee', 'buffer' },
          },
          providers = {
            lazydev = {
              name = 'LazyDev',
              module = 'lazydev.integrations.blink',
              score_offset = 100,
            },
            laravel = {
              name = 'Laravel',
              module = 'laravel.blink_source',
            },
            cmdline = {
              min_keyword_length = 2,
            },
            dadbod = {
              name = 'Dadbod',
              module = 'vim_dadbod_completion.blink',
            },
          },
        },
        -- My super-TAB configuration
        keymap = {
          ['<C-f>'] = {},
          ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<C-e>'] = { 'hide', 'fallback' },
          ['<CR>'] = { 'accept', 'fallback' },

          ['<Tab>'] = {
            UserUtil.cmp.map({ 'snippet_forward', 'ai_accept' }),
            'fallback',
          },
          ['<S-Tab>'] = {
            'snippet_backward',
            'fallback',
          },

          ['<Up>'] = { 'select_prev', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },
          ['<C-p>'] = { 'select_prev', 'fallback' },
          ['<C-n>'] = { 'select_next', 'fallback' },
          ['<C-up>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-down>'] = { 'scroll_documentation_down', 'fallback' },
        },
        cmdline = {
          enabled = false,
          completion = { menu = { auto_show = true } },
          keymap = {
            ['<CR>'] = { 'accept_and_enter', 'fallback' },
          },
        },
        completion = {
          accept = { auto_brackets = { enabled = false } },
          menu = {
            border = nil,
            scrolloff = 1,
            scrollbar = false,
            draw = {
              columns = {
                { 'kind_icon' },
                { 'label', 'label_description', gap = 1 },
                { 'kind' },
                { 'source_name' },
              },
            },
          },
          documentation = {
            window = {
              border = 'rounded',
              scrollbar = false,
              winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc',
            },
            auto_show = true,
            auto_show_delay_ms = 500,
          },
        },
      })

      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
}
