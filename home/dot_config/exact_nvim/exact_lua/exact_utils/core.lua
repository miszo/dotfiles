local M = {}

local supported_images = { 'png', 'jpg', 'jpeg', 'gif', 'webp', 'avif' }

M.get_hijack_images_patterns = function()
  local patterns = {}

  for _, extension in ipairs(supported_images) do
    table.insert(patterns, string.format('*.%s', extension))
  end

  return patterns
end

M.get_extension = function(filepath)
  local split_path = vim.split(filepath:lower(), '.', { plain = true })
  return split_path[#split_path]
end

M.is_supported_image = function(filepath)
  local extension = M.get_extension(filepath)
  return vim.tbl_contains(supported_images, extension)
end

return M
