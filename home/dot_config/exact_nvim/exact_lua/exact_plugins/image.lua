---@module "lazy"
---@type LazySpec[]
return {
  {
    'vhyrro/luarocks.nvim',
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { 'magick' },
    },
  },
  {
    '3rd/image.nvim',
    dependencies = { 'luarocks.nvim' },
    config = function(_, opts)
      opts.integrations = opts.integrations or {}
      opts.integrations.markdown = opts.integrations.markdown or {}
      opts.integrations.markdown.only_render_image_at_cursor = true
      opts.hijack_file_patterns = require('utils.core').get_hijack_images_patterns()
      opts.max_width_window_percentage = 80
      require('image').setup(opts)
    end,
  },
}
