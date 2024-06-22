local previewers = require('telescope.previewers')
local image_api = require('image')

local M = {}
local is_image_preview = false
local supported_images = { 'png', 'jpg', 'jpeg', 'heic', 'avif', 'gif', 'webp' }
local image = nil
local last_file_path = ''

local get_extension = function(filepath)
  local split_path = vim.split(filepath:lower(), '.', { plain = true })
  return split_path[#split_path]
end

local is_supported_image = function(filepath)
  local extension = get_extension(filepath)
  return vim.tbl_contains(supported_images, extension)
end

local delete_image = function()
  if not image then
    return
  end
  image:clear()
  is_image_preview = false
end

local create_image = function(filepath, winid, bufnr)
  image = image_api.from_file(filepath, { window = winid, buffer = bufnr })
  if not image then
    return
  end
  vim.defer_fn(function()
    image:render()
  end, 0)

  is_image_preview = true
end

M.buffer_previewer_maker = function(filepath, bufnr, opts)
  -- NOTE: Clear image when preview other file
  if is_image_preview and last_file_path ~= filepath then
    delete_image()
  end

  last_file_path = filepath

  local extension = get_extension(filepath)
  if is_supported_image(extension) then
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
