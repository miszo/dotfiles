local M = {}

local supported_images = { 'png', 'jpg', 'jpeg', 'gif', 'webp', 'avif' }

---Get patterns for hijacking images.
---@return table: A list of patterns for supported image extensions.
M.get_hijack_images_patterns = function()
  local patterns = {}

  for _, extension in ipairs(supported_images) do
    table.insert(patterns, string.format('*.%s', extension))
  end

  return patterns
end

---Get the extension of a given file path.
---@param filepath string: The path to the file.
---@return string: The file extension.
M.get_extension = function(filepath)
  local split_path = vim.split(filepath:lower(), '.', { plain = true })
  return split_path[#split_path]
end

---Check if the given file is a supported image.
---@param filepath string: The path to the file.
---@return boolean: True if the file is a supported image, false otherwise.
M.is_supported_image = function(filepath)
  local extension = M.get_extension(filepath)
  return vim.tbl_contains(supported_images, extension)
end

return M
