return {
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    priority = 1000,
    config = function(_, opts)
      table.insert(opts.integrations, { overseer = true, harpoon = true })
      opts.highlight_overrides = {
        mocha = function(mocha)
          return {
            PackageInfoOutdatedVersion = { fg = mocha.peach },
            PackageInfoUptodateVersion = { fg = mocha.green },
          }
        end,
      }
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme('catppuccin-mocha')
    end,
  },
}
