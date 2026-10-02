---@module 'lazy'
---@type LazySpec[]
return {
  -- Markdown preview
  {
    'selimacerbas/mdkite.nvim',
    cmd = { 'MdKite' },
    dependencies = { 'selimacerbas/kitehost.nvim' },
    keys = {
      {
        '<leader>mps',
        ft = { 'markdown', 'markdown.mdx' },
        '<cmd>MdKite start<cr>',
        desc = 'Markdown: Start preview',
      },
      {
        '<leader>mpS',
        ft = { 'markdown', 'markdown.mdx' },
        '<cmd>MdKite stop<cr>',
        desc = 'Markdown: Stop preview',
      },

      {
        '<leader>mpr',
        ft = { 'markdown', 'markdown.mdx' },
        '<cmd>MdKite refresh<cr>',
        desc = 'Markdown: Refresh preview',
      },
    },
    config = function()
      require('mdkite').setup({
        port = 8421,
        open_browser = true,
        debounce_ms = 300,
      })
    end,
  },
  -- Markdown rendering
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
      },
      'nvim-mini/mini.icons',
    },
    ft = { 'markdown', 'markdown.mdx' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      bullet = {
        -- Turn on / off list bullet rendering
        enabled = true,
      },
      checkbox = {
        -- Turn on / off checkbox state rendering
        enabled = true,
        -- Determines how icons fill the available space:
        --  inline:  underlying text is concealed resulting in a left aligned icon
        --  overlay: result is left padded with spaces to hide any additional text
        position = 'inline',
        unchecked = {
          -- Replaces '[ ]' of 'task_list_marker_unchecked'
          icon = '   󰄱 ',
          -- Highlight for the unchecked icon
          highlight = 'RenderMarkdownUnchecked',
          -- Highlight for item associated with unchecked checkbox
          scope_highlight = nil,
        },
        checked = {
          -- Replaces '[x]' of 'task_list_marker_checked'
          icon = '   󰱒 ',
          -- Highlight for the checked icon
          highlight = 'RenderMarkdownChecked',
          -- Highlight for item associated with checked checkbox
          scope_highlight = nil,
        },
      },
      latex = { enabled = false },
      html = {
        -- Turn on / off all HTML rendering
        enabled = true,
        comment = {
          -- Turn on / off HTML comment concealing
          conceal = false,
        },
      },
      heading = {
        sign = false,
        icons = { '󰎤 ', '󰎧 ', '󰎪 ', '󰎭 ', '󰎱 ', '󰎳 ' },
      },
    },
  },
}
