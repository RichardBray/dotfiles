local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- General
config.font_size = 19
config.line_height = 1.1
config.font = wezterm.font "BlexMono Nerd Font Mono"
config.color_scheme = 'tokyonight_night'
config.window_close_confirmation = 'NeverPrompt' -- For quitting WezTerm
config.max_fps = 120
config.animation_fps = 120

-- Cursor
config.colors = {
  cursor_bg = '#7aa2f7',
  cursor_border = '#7aa2f7'
}

-- Appearance
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.window_padding = {
  bottom = 0
}

-- Key bindings
config.keys = {
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  { 
    key = 'k', 
    mods = 'CMD', 
    action = wezterm.action.SendString 'clear\n' 
  },
  {
    key = '+',
    mods = 'CTRL',
    action = wezterm.action.Multiple {
      wezterm.action.IncreaseFontSize,
      wezterm.action.EmitEvent('show-zoom'),
    },
  },
  {
    key = '-',
    mods = 'CTRL',
    action = wezterm.action.Multiple {
      wezterm.action.DecreaseFontSize,
      wezterm.action.EmitEvent('show-zoom'),
    },
  },
  {
    key = '0',
    mods = 'CTRL',
    action = wezterm.action.Multiple {
      wezterm.action.ResetFontSize,
      wezterm.action.EmitEvent('show-zoom'),
    },
  },
}

-- Event handler to show zoom percentage
wezterm.on('show-zoom', function(window, pane)
  local font_size = window:effective_font_size()
  local base_size = 19 -- Your default font size
  local zoom_percent = math.floor((font_size / base_size - 1) * 100 + 0.5)
  
  local message = zoom_percent == 0 and "100%" or string.format("%+d%%", zoom_percent)
  wezterm.log_error("Zoom event: " .. message)
  
  if zoom_percent == 0 then
    window:toast_notification("Zoom", "100%")
  else
    window:toast_notification("Zoom", string.format("%+d%%", zoom_percent))
  end
end)

-- Ensure Option key sends composed characters (e.g., #)
config.send_composed_key_when_left_alt_is_pressed = true

-- SSH
config.ssh_domains = {
  {
    name = 'hetzner',
    remote_address = '157.180.112.216',
    username = 'root',
    ssh_option = {
      identityfile = '~/.ssh/hetzner',
    }
  },
}

return config
