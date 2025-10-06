---@param name string augroup name, will be prefixed with `user_nvim_`
---@param opts? vim.api.keyset.create_augroup `create_augroup` options, default is `{ clear = true}`
---@return integer augroup_id
local function augroup(name, opts)
  opts = opts or { clear = true }
  return vim.api.nvim_create_augroup('user_nvim_' .. name, opts)
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup('resize_splits'),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('close_with_q'),
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dbout',
    'gitsigns-blame',
    'grug-far',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
    'startuptime',
    'tsplayground',
    'snacks_dashboard',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd('close')
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('man_unlisted'),
  pattern = { 'man' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('wrap_spell'),
  pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup('json_conceal'),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = augroup('auto_create_dir'),
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup('lsp-attach'),
  callback = function(attach_event)
    local client = vim.lsp.get_client_by_id(attach_event.data.client_id)

    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = attach_event.buf, desc = 'LSP: ' .. desc })
    end

    map('gl', vim.diagnostic.open_float, 'Open Diagnostic Float')
    map('K', function()
      vim.lsp.buf.hover({ border = 'rounded' })
    end, 'Hover Documentation')
    map('gs', vim.lsp.buf.signature_help, 'Signature Documentation')
    map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

    map('<leader>v', '<cmd>vsplit | lua vim.lsp.buf.definition()<cr>', 'Goto Definition in Vertical Split')

    local wk = require('which-key')
    wk.add({
      { '<leader>ci', Snacks.picker.lsp_config, desc = 'Lsp Info' },
      { 'gD', Snacks.picker.lsp_declarations, desc = 'Goto Declaration' },
      { 'gr', Snacks.picker.lsp_references, nowait = true, desc = 'References' },
      { 'gI', Snacks.picker.lsp_implementations, desc = 'Goto Implementation' },
      { 'gy', Snacks.picker.lsp_type_definitions, desc = 'Goto T[y]pe Definition' },
      {
        '<leader>ss',
        function()
          Snacks.picker.lsp_symbols({
            filter = UserConfig.kind_filter,
            layout = { preset = 'vscode', preview = 'main' },
          })
        end,
        desc = 'LSP Symbols',
      },
      {
        '<leader>sS',
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = 'LSP Workspace Symbols',
      },
    })

    if client and client.name == 'vtsls' then
      local function ts_code_action(action)
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            only = { action },
            diagnostics = {},
          },
        })
      end
      wk.add({
        {
          '<leader>cM',
          function()
            ts_code_action('source.addMissingImports.ts')
          end,
          desc = 'Add missing imports',
        },
        {
          '<leader>cu',
          function()
            ts_code_action('source.removeUnused.ts')
          end,
          desc = 'Remove unused imports',
        },
        {
          '<leader>cD',
          function()
            ts_code_action('source.fixAll.ts')
          end,
          desc = 'Fix all diagnostics',
        },
        {
          '<leader>cV',
          function()
            vim.lsp.buf_request(
              0,
              vim.lsp.protocol.Methods.workspace_executeCommand,
              { command = 'typescript.selectTypeScriptVersion' }
            )
          end,
          desc = 'Select TS workspace version',
        },
      })
    end

    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_definition, attach_event.buf) then
      wk.add({
        { 'gd', Snacks.picker.lsp_definitions, desc = 'Goto Definition' },
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_rename, attach_event.buf) then
      wk.add({
        { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename symbol' },
      })
    end

    if
      client
      and client:supports_method(vim.lsp.protocol.Methods.workspace_didRenameFiles, attach_event.buf)
      and client:supports_method(vim.lsp.protocol.Methods.workspace_willRenameFiles, attach_event.buf)
    then
      wk.add({
        {
          '<leader>cR',
          function()
            Snacks.rename.rename_file()
          end,
          desc = 'Rename File',
        },
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeAction, attach_event.buf) then
      wk.add({
        {
          '<leader>ca',
          vim.lsp.buf.code_action,
          desc = 'Code Action',
        },
        {
          '<leader>cA',
          function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { 'source.fixAll', 'source', 'source.fixAll.biome', 'source.biome' },
                diagnostics = {},
              },
            })
          end,
          desc = 'Source Action',
        },
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens, attach_event.buf) then
      wk.add({
        { '<leader>cc', vim.lsp.codelens.run, desc = 'Run Codelens', mode = { 'n', 'v' } },
        { '<leader>cC', vim.lsp.codelens.refresh, desc = 'Refresh & Display Codelens', mode = { 'n' } },
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_signatureHelp, attach_event.buf) then
      wk.add({
        {
          'gK',
          function()
            return vim.lsp.buf.signature_help()
          end,
          desc = 'Signature Help',
        },
        {
          '<c-k>',
          function()
            return vim.lsp.buf.signature_help()
          end,
          mode = 'i',
          desc = 'Signature Help',
        },
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, attach_event.buf) then
      wk.add({
        {
          ']]',
          function()
            Snacks.words.jump(vim.v.count1)
          end,
          desc = 'Next Reference',
        },
        {
          '[[',
          function()
            Snacks.words.jump(-vim.v.count1)
          end,
          desc = 'Prev Reference',
        },
        {
          '<a-n>',
          function()
            Snacks.words.jump(vim.v.count1, true)
          end,
          desc = 'Next Reference',
        },
        {
          '<a-p>',
          function()
            Snacks.words.jump(-vim.v.count1, true)
          end,
          desc = 'Prev Reference',
        },
      })

      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
      end

      local highlight_augroup = augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = attach_event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = attach_event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = augroup('lsp-detach'),
        callback = function(detach_event)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = detach_event.buf })
        end,
      })
    end
  end,
})

-- Disable the diagnostics in files from ther `/node_modules/` directory
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'svelte', 'astro' },
  callback = function()
    if vim.fn.expand('%:p'):match('/node_modules/') then
      vim.diagnostic.enable(false)
    end
  end,
})

-- Autoformat autocmd
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('UserFormat', {}),
  callback = function(event)
    UserUtil.formatting.format({ buf = event.buf })
  end,
})

-- Manual format
vim.api.nvim_create_user_command('Format', function()
  UserUtil.formatting.format({ force = true })
end, { desc = 'Format selection or buffer' })

-- Format info
vim.api.nvim_create_user_command('FormatInfo', function()
  UserUtil.formatting.info()
end, { desc = 'Show info about the formatters for the current buffer' })

-- Handle file renames for LSP in Oil
vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPost',
  callback = function(event)
    if event.data.actions.type == 'move' then
      Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    end
  end,
})

-- Auto toggle relative number
local number_augroup = augroup('numbertoggle', {})

local function set_relativenumber(is_relative, redraw)
  local is_insert_mode = vim.api.nvim_get_mode().mode == 'i'

  vim.o.number = not is_relative or is_insert_mode or current_number
  vim.o.relativenumber = is_relative and not is_insert_mode

  if redraw then
    vim.cmd('redraw')
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
  pattern = '*',
  group = number_augroup,
  callback = function(event)
    set_relativenumber(true, event.event == 'CmdlineEnter')
  end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
  pattern = '*',
  group = number_augroup,
  callback = function(event)
    set_relativenumber(false, event.event == 'CmdlineEnter')
  end,
})
