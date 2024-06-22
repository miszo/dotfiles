local previewers = require('telescope.previewers')
local image_api = require('image')
local utils = require('utils.core')

local M = {}
local is_image_preview = false
local image = nil
local last_file_path = ''

local delete_image = function()
  if not image then
    return
  end

  image:clear()

  is_image_preview = false
end

local create_image = function(filepath, winid, bufnr)
  image = image_api.hijack_buffer(filepath, winid, bufnr)

  if not image then
    return
  end

  vim.schedule(function()
    image:render()
  end)

  is_image_preview = true
end

M.buffer_previewer_maker = function(filepath, bufnr, opts)
  -- NOTE: Clear image when preview other file
  if is_image_preview and last_file_path ~= filepath then
    delete_image()
  end

  last_file_path = filepath

  if utils.is_supported_image(filepath) then
    create_image(filepath, opts.winid, bufnr)
  else
    previewers.buffer_previewer_maker(filepath, bufnr, opts)
  end
end

M.teardown = function(_)
  if is_image_preview then
    delete_image()
  end
end

return M
