local wezterm = require('wezterm') --[[@as Wezterm]]
local act = wezterm.action
local M = {}

local function is_nvim(pane)
  local tty = pane:get_tty_name()
  if tty == nil then
    return false
  end

  local success, _, _ = wezterm.run_child_process({
    'sh',
    '-c',
    'ps -o state= -o comm= -t'
      .. wezterm.shell_quote_arg(tty)
      .. ' | '
      .. "grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'",
  })

  return success
end

local function activate_pane(window, pane, pane_direction, vim_direction)
  if is_nvim(pane) then
    window:perform_action(
      act.Multiple({
        act.SendKey({ key = 'w', mods = 'CTRL' }),
        act.SendKey({ key = vim_direction }),
      }),
      pane
    )
  else
    window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
  end
end

---@param config Config
function M.setup(config)
  wezterm.on('ActivatePaneRight', function(window, pane)
    activate_pane(window, pane, 'Right', 'l')
  end)
  wezterm.on('ActivatePaneLeft', function(window, pane)
    activate_pane(window, pane, 'Left', 'h')
  end)
  wezterm.on('ActivatePaneUp', function(window, pane)
    activate_pane(window, pane, 'Up', 'k')
  end)
  wezterm.on('ActivatePaneDown', function(window, pane)
    activate_pane(window, pane, 'Down', 'j')
  end)

  config.leader = { key = 'b', mods = 'CRTL', timeout_milliseconds = 2000 }
  config.keys = {
    -- Pane keybindings
    { key = '-', mods = 'LEADER', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
    { key = '\\', mods = 'LEADER', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },

    { key = 'q', mods = 'LEADER', action = act.CloseCurrentPane({ confirm = true }) },
    { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
    { key = 'o', mods = 'LEADER', action = act.RotatePanes('Clockwise') },

    -- Tab keybindings
    { key = 't', mods = 'LEADER', action = act.SpawnTab('CurrentPaneDomain') },
    { key = '[', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    { key = ']', mods = 'LEADER', action = act.ActivateTabRelative(1) },
    { key = 'n', mods = 'LEADER', action = act.ShowTabNavigator },
    -- Key table for moving tabs around
    { key = 'm', mods = 'LEADER', action = act.ActivateKeyTable({ name = 'move_tab', one_shot = false }) },
    -- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
    { key = '{', mods = 'LEADER', action = act.MoveTabRelative(-1) },
    { key = '}', mods = 'LEADER', action = act.MoveTabRelative(1) },

    -- Lastly, workspace
    { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }) },

    -- activates the debug overlay
    { key = 'l', mods = 'LEADER', action = wezterm.action.ShowDebugOverlay },

    -- Neovim integration
    { key = 'h', mods = 'CTRL', action = act.EmitEvent('ActivatePaneLeft') },
    { key = 'j', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDown') },
    { key = 'k', mods = 'CTRL', action = act.EmitEvent('ActivatePaneUp') },
    { key = 'l', mods = 'CTRL', action = act.EmitEvent('ActivatePaneRight') },

    { mods = 'ALT', key = 'LeftArrow', action = act.SendString('\x1b\x62') },
    { mods = 'ALT', key = 'RightArrow', action = act.SendString('\x1b\x66') },
    { mods = 'ALT', key = 'Backspace', action = act.SendString('\x17') },
    { mods = 'CMD', key = 'LeftArrow', action = act.SendString('X1bOH') },
    { mods = 'CMD', key = 'RightArrow', action = act.SendString('\x1bOF') },
    { mods = 'CMD', key = 'Backspace', action = act.SendString('\x15') },
  }

  for i = 1, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = 'LEADER',
      action = act.ActivateTab(i - 1),
    })
  end
end

return M
