local Util = require('lazyvim.util')

return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'johmsalas/text-case.nvim',
    },
    keys = {
      { '<leader>fR', Util.pick('resume'), desc = 'Resume' },
      {
        '<leader>sB',
        ':Telescope file_browser file_browser path=%:p:h=%:p:h<cr>',
        desc = 'Browse Files',
      },
      {
        '<leader>fP',
        function()
          require('telescope.builtin').find_files({
            cwd = require('lazy.core.config').options.root,
          })
        end,
        desc = 'Find Plugin File',
      },
      {
        'sf',
        function()
          local telescope = require('telescope')

          local function telescope_buffer_dir()
            return vim.fn.expand('%:p:h')
          end

          telescope.extensions.file_browser.file_browser({
            path = '%:p:h',
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = 'normal',
            layout_config = { height = 40 },
          })
        end,
        desc = 'Open File Browser with the path of the current buffer',
      },
      { '<leader>fN', ':Telescope noice<cr>', desc = 'Noice' },
    },
    config = function(_, opts)
      require('textcase').setup()
      local telescope = require('telescope')
      opts.extensions = { file_browser = { hijack_netrw = true } }
      opts.defaults.vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '-B=0',
        '-A=0',
      }
      telescope.setup(opts)
      telescope.load_extension('undo')
      telescope.load_extension('file_browser')
      telescope.load_extension('fzf')
      telescope.load_extension('textcase')
      telescope.load_extension('noice')
      vim.keymap.set('n', 'ga.', '<cmd>TextCaseOpenTelescope<CR>', { desc = 'Telescope' })
      vim.keymap.set('v', 'ga.', '<cmd>TextCaseOpenTelescope<CR>', { desc = 'Telescope' })
    end,
  },
}
