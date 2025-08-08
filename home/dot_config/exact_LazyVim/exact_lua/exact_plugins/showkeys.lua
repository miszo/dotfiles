---@module "lazy"
---@type LazySpec[]
return {
  {
    'nvzone/showkeys',
    cmd = 'ShowkeysToggle',
    opts = {
      timeout = 1,
      maxkeys = 5,
      excluded_modes = { 'i' },
      position = 'bottom-right',
    },
  },
}
