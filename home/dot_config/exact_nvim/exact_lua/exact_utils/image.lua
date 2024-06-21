local M = {}

--- Get the extension of a file
--- @filepath: string
M.get_extension = function(filepath)
  local split_path = vim.split(filepath:lower(), '.', { plain = true })
  return split_path[#split_path]
end

--- Check if the file is an image
--- @filepath: string
M.is_image = function(filepath)
  local image_extensions = { 'png', 'jpg', 'jpeg', 'heic', 'avif', 'gif', 'webp' } -- Supported image formats
  local extension = M.get_extension(filepath)
  return vim.tbl_contains(image_extensions, extension)
end

return M
