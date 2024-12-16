---@diagnostic disable: missing-fields, inject-field
return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'saghen/blink.compat',
      'hrsh7th/cmp-emoji',
    },
    opts_extend = {
      'sources.completion.enabled_providers',
      'sources.compat',
      'sources.providers',
      'sources.default',
    },
    ---@module 'blink.cmp'
    ---@param opts blink.cmp.Config
    opts = function(_, opts)
      opts.completion = opts.completion or {}
      opts.completion.menu = opts.completion.menu or {}
      opts.completion.menu.draw = opts.completion.menu.draw or {}
      opts.completion.menu.draw.columns = {
        { 'kind_icon' },
        { 'label', 'label_description', gap = 1 },
        { 'kind' },
      }

      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}
      opts.sources.default = vim.tbl_extend('force', opts.sources.default, { 'emoji' })
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.emoji = {
        name = 'emoji',
        module = 'blink.compat.source',
        kind = 'Emoji',
        score_offset = -3,
      }
    end,
  },
}
