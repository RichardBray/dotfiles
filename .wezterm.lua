local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- General
config.default_prog = { '/run/current-system/sw/bin/fish', '-l' }
config.font_size = 19
config.line_height = 1.1
config.font = wezterm.font "BlexMono Nerd Font Mono"
config.color_scheme = 'tokyonight_night'
config.window_close_confirmation = 'NeverPrompt' -- For quitting WezTerm

-- Performance Hack
config.max_fps = 120
config.animation_fps = 120

-- Cursor
config.colors = {
  cursor_bg = '#7aa2f7',
  cursor_border = '#7aa2f7',
}

config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.3,
}

-- Appearance
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
-- config.tab_bar_at_bottom = true
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


-- Ensure Option key sends composed characters (e.g., #)
config.send_composed_key_when_left_alt_is_pressed = true

return config

