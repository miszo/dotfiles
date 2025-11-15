---@module 'lazy'
---@type LazySpec[]
return {
  {
    'dmmulroy/ts-error-translator.nvim',
    opts = {
      auto_attach = true,
      servers = {
        'angularls',
        'astro',
        'svelte',
        'vtsls',
        'vue_ls',
      },
    },
  },
  {
    'dmmulroy/tsc.nvim',
    lazy = true,
    ft = { 'typescript', 'typescriptreact' },
    cmd = 'TSC',
    keys = {
      { '<leader>tc', '<cmd>TSC<cr>', desc = 'Type-check' },
    },
    config = function()
      require('tsc').setup({
        auto_open_qflist = true,
        pretty_errors = false,
        ---@diagnostic disable-next-line: assign-type-mismatch
        flags = '--noEmit --pretty false', -- This just works
      })
    end,
  },
  {
    'typed-rocks/ts-worksheet-neovim',
    config = function(_, opts)
      require('tsw').setup(opts)
      local function map(key, cmd, desc)
        vim.keymap.set({ 'n' }, '<leader>W' .. key, cmd, { desc = desc, silent = true, noremap = true })
      end
      map('n', '<cmd>Tsw rt=node show_variables=true show_order=true<cr>', 'Run Tsw with Node')
      map('d', '<cmd>Tsw rt=deno show_variables=true show_order=true<cr>', 'Run Tsw with Deno')
      map('b', '<cmd>Tsw rt=bun show_variables=true show_order=true<cr>', 'Run Tsw with Bun')
    end,
  },
}
