local wezterm = require('wezterm')
local act = wezterm.action

local function isVim(pane)
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

local function activatePane(window, pane, direction, vim_key)
  if isVim(pane) then
    window:perform_action(
      -- act.Multiple({
      --   act.SendKey({ key = 'w', mods = 'CTRL' }),
      --   act.SendKey({ key = vim_key }),
      -- }),
      act.SendKey({ key = vim_key, mods = 'CTRL|ALT' }),
      pane
    )
  else
    window:perform_action(act.ActivatePaneDirection(direction), pane)
  end
end

wezterm.on('ActivatePaneRight', function(window, pane)
  activatePane(window, pane, 'Right', 'l')
end)
wezterm.on('ActivatePaneLeft', function(window, pane)
  activatePane(window, pane, 'Left', 'h')
end)
wezterm.on('ActivatePaneUp', function(window, pane)
  activatePane(window, pane, 'Up', 'k')
end)
wezterm.on('ActivatePaneDown', function(window, pane)
  activatePane(window, pane, 'Down', 'j')
end)

local keys = {
  -- Send C-a when pressing C-a twice
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey({ key = 'a', mods = 'CTRL' }) },
  -- Pane keybindings
  { key = 's', mods = 'LEADER', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
  { key = 'v', mods = 'LEADER', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },

  { key = 'q', mods = 'LEADER', action = act.CloseCurrentPane({ confirm = true }) },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'o', mods = 'LEADER', action = act.RotatePanes('Clockwise') },

  -- Tab keybindings
  { key = 't', mods = 'LEADER', action = act.SpawnTab('CurrentPaneDomain') },
  { key = '[', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'n', mods = 'LEADER', action = act.ShowTabNavigator },
  {
    key = 'e',
    mods = 'LEADER',
    action = act.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Renaming Tab Title...:' },
      }),
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  -- Key table for moving tabs around
  { key = 'm', mods = 'LEADER', action = act.ActivateKeyTable({ name = 'move_tab', one_shot = false }) },
  -- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
  { key = '{', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(-1) },
  { key = '}', mods = 'LEADER|SHIFT', action = act.MoveTabRelative(1) },

  -- Lastly, workspace
  { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }) },

  -- Neovim integration
  { key = 'h', mods = 'CTRL', action = act.EmitEvent('ActivatePaneLeft') },
  { key = 'j', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDown') },
  { key = 'k', mods = 'CTRL', action = act.EmitEvent('ActivatePaneUp') },
  { key = 'l', mods = 'CTRL', action = act.EmitEvent('ActivatePaneRight') },
}

return keys
