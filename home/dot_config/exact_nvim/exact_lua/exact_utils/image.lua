local image_api = require('image')

local M = {}
local is_image_preview = false
local image = nil

local delete_image = function()
  if not image then
    return
  end

  image:clear()

  is_image_preview = false
end

M.render_image = function(filepath, winid, bufnr)
  image = image_api.hijack_buffer(filepath, winid, bufnr)

  if not image then
    return
  end

  vim.schedule(function()
    image:render()
  end)

  is_image_preview = true
end

M.teardown = function(_)
  if is_image_preview then
    delete_image()
  end
end

return M
