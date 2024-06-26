local wezterm = require('wezterm')
local mux = wezterm.mux
local keys = require('utils.keys')

wezterm.on('gui-startup', function()
  local _, _, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Catppuccin Mocha'
config.scrollback_lines = 4000
config.default_workspace = 'main'

config.font = wezterm.font_with_fallback({
  { family = 'Monolisa Variable', harfbuzz_features = { 'calt=1', 'liga=1', 'ss02=1' } },
  'Apple Color Emoji',
  'Symbols Nerd Font Mono',
})
config.font_size = 14.0
config.line_height = 1.2
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = keys
config.mouse_bindings = {
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

config.front_end = 'WebGpu'
config.enable_kitty_graphics = true
config.window_decorations = 'RESIZE'
config.window_close_confirmation = 'AlwaysPrompt'
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.tab_max_width = 30
config.automatically_reload_config = true
config.default_cursor_style = 'SteadyBar'

config.status_update_interval = 1000

wezterm.on('update-status', function(window, pane)
  -- Workspace name
  local stat = window:active_workspace()
  local stat_color = '#f38ba8'
  -- It's a little silly to have workspace name all the time
  -- Utilize this to display LDR or current key table name
  if window:active_key_table() then
    stat = window:active_key_table()
    stat_color = '#74c7ec'
  end
  if window:leader_is_active() then
    stat = 'LDR'
    stat_color = '#b4befe'
  end

  local basename = function(s)
    -- Nothing a little regex can't fix
    return string.gsub(s, '(.*[/\\])(.*)', '%2')
  end

  -- Current working directory
  local cwd = pane:get_current_working_dir()
  if cwd then
    if type(cwd) == 'userdata' then
      -- Wezterm introduced the URL object in 20240127-113634-bbcac864
      cwd = basename(cwd.file_path)
    else
      -- 20230712-072601-f4abf8fd or earlier version
      cwd = basename(cwd)
    end
  else
    cwd = ''
  end

  -- Current command
  local cmd = pane:get_foreground_process_name()
  -- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
  cmd = cmd and basename(cmd) or ''

  -- Time
  local time = wezterm.strftime('%H:%M')

  -- Left status (left of the tab line)
  window:set_left_status(wezterm.format({
    { Foreground = { Color = stat_color } },
    { Text = '  ' },
    { Text = wezterm.nerdfonts.oct_table .. '  ' .. stat },
    { Text = ' |' },
  }))

  -- Right status
  window:set_right_status(wezterm.format({
    -- Wezterm has a built-in nerd fonts
    -- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
    { Text = wezterm.nerdfonts.md_folder .. '  ' .. cwd },
    { Text = ' | ' },
    { Foreground = { Color = '#fab387' } },
    { Text = wezterm.nerdfonts.fa_code .. '  ' .. cmd },
    'ResetAttributes',
    { Text = ' | ' },
    { Text = wezterm.nerdfonts.md_clock .. '  ' .. time },
    { Text = '  ' },
  }))
end)

return config
