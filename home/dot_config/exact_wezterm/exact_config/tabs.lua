local wezterm = require('wezterm') --[[@as Wezterm]]

local M = {}
M.right_arrow_thick = wezterm.nerdfonts.ple_right_half_circle_thick
M.right_arrow_thin = wezterm.nerdfonts.ple_rigth_half_circle_thin

M.left_arrow_tick = wezterm.nerdfonts.ple_left_half_circle_thick
M.left_arrow_thin = wezterm.nerdfonts.ple_left_half_circle_thin
M.icons = {
  ['cargo'] = wezterm.nerdfonts.dev_rust,
  ['chezmoi'] = wezterm.nerdfonts.custom_folder_config,
  ['curl'] = wezterm.nerdfonts.mdi_flattr,
  ['docker'] = wezterm.nerdfonts.linux_docker,
  ['docker-compose'] = wezterm.nerdfonts.linux_docker,
  ['gh'] = wezterm.nerdfonts.dev_github_badge,
  ['git'] = wezterm.nerdfonts.dev_git,
  ['glab'] = wezterm.nerdfonts.seti_gitlab,
  ['go'] = wezterm.nerdfonts.seti_go,
  ['htop'] = wezterm.nerdfonts.md_chart_areaspline,
  ['btop'] = wezterm.nerdfonts.md_chart_areaspline,
  ['kubectl'] = wezterm.nerdfonts.linux_docker,
  ['kuberlr'] = wezterm.nerdfonts.linux_docker,
  ['lazydocker'] = wezterm.nerdfonts.linux_docker,
  ['lazygit'] = wezterm.nerdfonts.cod_github,
  ['lua'] = wezterm.nerdfonts.seti_lua,
  ['make'] = wezterm.nerdfonts.seti_makefile,
  ['node'] = wezterm.nerdfonts.mdi_hexagon,
  ['nvim'] = wezterm.nerdfonts.custom_neovim,
  ['op'] = wezterm.nerdfonts.md_onepassword,
  ['psql'] = wezterm.nerdfonts.dev_postgresql,
  ['ruby'] = wezterm.nerdfonts.cod_ruby,
  ['sudo'] = wezterm.nerdfonts.fa_bolt,
  ['vim'] = wezterm.nerdfonts.dev_vim,
  ['zsh'] = wezterm.nerdfonts.dev_terminal,
  ['folder'] = wezterm.nerdfonts.md_folder,
  ['clock'] = wezterm.nerdfonts.md_clock,
  ['fallback'] = wezterm.nerdfonts.dev_code,
}

local hour_to_icon = {
  ['00'] = wezterm.nerdfonts.md_clock_time_twelve_outline,
  ['01'] = wezterm.nerdfonts.md_clock_time_one_outline,
  ['02'] = wezterm.nerdfonts.md_clock_time_two_outline,
  ['03'] = wezterm.nerdfonts.md_clock_time_three_outline,
  ['04'] = wezterm.nerdfonts.md_clock_time_four_outline,
  ['05'] = wezterm.nerdfonts.md_clock_time_five_outline,
  ['06'] = wezterm.nerdfonts.md_clock_time_six_outline,
  ['07'] = wezterm.nerdfonts.md_clock_time_seven_outline,
  ['08'] = wezterm.nerdfonts.md_clock_time_eight_outline,
  ['09'] = wezterm.nerdfonts.md_clock_time_nine_outline,
  ['10'] = wezterm.nerdfonts.md_clock_time_ten_outline,
  ['11'] = wezterm.nerdfonts.md_clock_time_eleven_outline,
  ['12'] = wezterm.nerdfonts.md_clock_time_twelve,
  ['13'] = wezterm.nerdfonts.md_clock_time_one,
  ['14'] = wezterm.nerdfonts.md_clock_time_two,
  ['15'] = wezterm.nerdfonts.md_clock_time_three,
  ['16'] = wezterm.nerdfonts.md_clock_time_four,
  ['17'] = wezterm.nerdfonts.md_clock_time_five,
  ['18'] = wezterm.nerdfonts.md_clock_time_six,
  ['19'] = wezterm.nerdfonts.md_clock_time_seven,
  ['20'] = wezterm.nerdfonts.md_clock_time_eight,
  ['21'] = wezterm.nerdfonts.md_clock_time_nine,
  ['22'] = wezterm.nerdfonts.md_clock_time_ten,
  ['23'] = wezterm.nerdfonts.md_clock_time_eleven,
}

local palette = {
  rosewater = '#f5e0dc',
  flamingo = '#f2cdcd',
  pink = '#f5c2e7',
  mauve = '#cba6f7',
  red = '#f38ba8',
  maroon = '#eba0ac',
  peach = '#fab387',
  yellow = '#f9e2af',
  green = '#a6e3a1',
  teal = '#94e2d5',
  sky = '#89dceb',
  sapphire = '#74c7ec',
  blue = '#89b4fa',
  lavender = '#b4befe',
  text = '#cdd6f4',
  subtext1 = '#bac2de',
  subtext0 = '#a6adc8',
  overlay2 = '#9399b2',
  overlay1 = '#7f849c',
  overlay0 = '#6c7086',
  surface2 = '#585b70',
  surface1 = '#45475a',
  surface0 = '#313244',
  base = '#1e1e2e',
  mantle = '#181825',
  crust = '#11111b',
}

local battery_icons = {
  ['Charging'] = wezterm.nerdfonts.md_battery_charging,
  ['Discharging'] = wezterm.nerdfonts.md_battery_arrow_down,
  ['Empty'] = wezterm.nerdfonts.md_battery_outline,
  ['Full'] = wezterm.nerdfonts.md_battery_heart_variant,
  ['Unknown'] = wezterm.nerdfonts.md_power_plug,
}

local battery_colors = {
  ['Charging'] = palette.sapphire,
  ['Discharging'] = palette.peach,
  ['Empty'] = palette.red,
  ['Full'] = palette.green,
  ['Unknown'] = palette.subtext1,
}

---@param tab MuxTabObj
---@param max_width number
function M.title(tab, max_width)
  local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
  local process, other = title:match('^(%S+)%s*%-?%s*%s*(.*)$')

  if M.icons[process] then
    title = M.icons[process] .. ' ' .. (other or '')
  end

  local is_zoomed = false
  for _, pane in ipairs(tab.panes) do
    if pane.is_zoomed then
      is_zoomed = true
      break
    end
  end
  if is_zoomed then -- or (#tab.panes > 1 and not tab.is_active) then
    title = wezterm.nerdfonts.fa_bars .. ' ' .. title
  end

  title = wezterm.truncate_right(title, max_width - 3)
  return ' ' .. title .. ' '
end

---@param config Config
function M.setup(config)
  config.enable_tab_bar = true
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.hide_tab_bar_if_only_one_tab = false
  config.tab_max_width = 32
  config.unzoom_on_switch_pane = true

  wezterm.on('format-tab-title', function(tab, tabs, _, event_config, _, max_width)
    local title = M.title(tab, max_width)
    local colors = event_config.resolved_palette
    local active_bg = colors.tab_bar.active_tab.bg_color
    local inactive_bg = colors.tab_bar.inactive_tab.bg_color

    local tab_idx = 1
    for i, t in ipairs(tabs) do
      if t.tab_id == tab.tab_id then
        tab_idx = i
        break
      end
    end
    local is_last = tab_idx == #tabs
    local next_tab = tabs[tab_idx + 1]
    local next_is_active = next_tab and next_tab.is_active
    local arrow = (tab.is_active or is_last or next_is_active) and M.right_arrow_thick or M.right_arrow_thin
    local arrow_bg = inactive_bg
    local arrow_fg = colors.tab_bar.inactive_tab_edge

    if is_last then
      arrow_fg = tab.is_active and active_bg or inactive_bg
      arrow_bg = colors.tab_bar.background
    elseif tab.is_active then
      arrow_bg = inactive_bg
      arrow_fg = active_bg
    elseif next_is_active then
      arrow_bg = active_bg
      arrow_fg = inactive_bg
    end

    local ret = tab.is_active
        and {
          { Attribute = { Intensity = 'Bold' } },
          { Attribute = { Italic = true } },
        }
      or {}
    ret[#ret + 1] = { Text = title }
    ret[#ret + 1] = { Foreground = { Color = arrow_fg } }
    ret[#ret + 1] = { Background = { Color = arrow_bg } }
    ret[#ret + 1] = { Text = arrow }
    return ret
  end)

  config.status_update_interval = 1000

  wezterm.on('update-status', function(window, pane)
    -- Workspace name
    local stat = window:active_workspace()
    local stat_color = palette.mauve
    if window:active_key_table() then
      stat = window:active_key_table()
      stat_color = palette.sky
    end
    if window:leader_is_active() then
      stat = 'LDR'
      stat_color = palette.pink
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
    local cmd_icon = M.icons[cmd] or M.icons['fallback']

    local battery = ''
    local battery_color = palette.text
    for _, b in ipairs(wezterm.battery_info()) do
      battery_color = battery_colors[b.state]
      battery = battery_icons[b.state] .. ' ' .. string.format('%.0f%%', b.state_of_charge * 100)
    end

    -- Time
    local time = wezterm.time.now()
    local formatted_time = time:format('%H:%M')
    local clock_icon = hour_to_icon[time:format('%H')]

    -- Left status (left of the tab line)
    window:set_left_status(wezterm.format({
      { Foreground = { Color = stat_color } },
      { Text = '  ' },
      { Text = wezterm.nerdfonts.cod_terminal_tmux .. '  ' .. stat },
      { Text = '  ' },
    }))

    -- Right status
    window:set_right_status(wezterm.format({
      --- Current path
      { Text = M.icons['folder'] .. '  ' .. cwd },

      -- Current command
      'ResetAttributes',
      { Foreground = { Color = palette.surface1 } },
      { Text = '  ' .. M.left_arrow_thin .. '  ' },
      'ResetAttributes',
      { Foreground = { Color = palette.blue } },
      { Text = cmd_icon .. '  ' .. cmd },

      -- Battery
      'ResetAttributes',
      { Foreground = { Color = palette.surface1 } },
      { Text = '  ' .. M.left_arrow_thin .. '  ' },
      'ResetAttributes',
      { Foreground = { Color = battery_color } },
      { Text = battery },

      -- Time
      { Foreground = { Color = palette.surface1 } },
      { Text = '  ' .. M.left_arrow_thin .. '  ' },
      'ResetAttributes',
      { Text = clock_icon .. '  ' .. formatted_time },
      { Text = '  ' },
    }))
  end)
end

return M
