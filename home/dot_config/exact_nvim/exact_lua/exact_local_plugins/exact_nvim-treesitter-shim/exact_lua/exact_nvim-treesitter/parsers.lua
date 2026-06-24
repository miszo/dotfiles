local M = {}

local configs = {}

function M.get_parser_configs()
  return configs
end

return setmetatable(M, {
  __index = function(_, key)
    return configs[key]
  end,
  __newindex = function(_, key, value)
    configs[key] = value
  end,
})
