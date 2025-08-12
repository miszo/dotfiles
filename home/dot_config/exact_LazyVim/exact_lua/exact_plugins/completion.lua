---@module 'lazy'
---@type LazySpec[]
return {
  {
    'saghen/blink.cmp',
    opts = function(_, opts)
      opts = opts or {}
      -- Just disable auto_brackets for completions
      opts.completion.accept.auto_brackets.enabled = false
    end,
  },
}
