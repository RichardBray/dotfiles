local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Filming mode: launch with `FIRECRAWL_FILMING=1 wezterm` to flip to Firecrawl Dark
local filming = os.getenv 'FIRECRAWL_FILMING' == '1'

config.color_schemes = {
  ['Firecrawl Dark'] = {
    foreground = '#d4d4d4',
    background = '#1e1e1e',
    cursor_bg = '#E97318',
    cursor_fg = '#1e1e1e',
    cursor_border = '#E97318',
    selection_bg = '#5a3a1a',
    selection_fg = '#d4d4d4',
    scrollbar_thumb = '#444444',
    split = '#444444',
    ansi = {
      '#1e1e1e', '#f44747', '#a0a0a0', '#E97318',
      '#E97318', '#ce9178', '#DCDCAA', '#d4d4d4',
    },
    brights = {
      '#858585', '#f44747', '#a0a0a0', '#FF9D4D',
      '#FF9D4D', '#fdba74', '#DCDCAA', '#ffffff',
    },
  },
}

-- General
config.default_prog = { '/run/current-system/sw/bin/fish', '-l' }
config.font_size = 16
config.line_height = 1.1
config.font = wezterm.font "BlexMono Nerd Font Mono"
config.color_scheme = filming and 'Firecrawl Dark' or 'tokyonight_night'
config.window_close_confirmation = 'NeverPrompt' -- For quitting WezTerm

-- Performance Hack
config.max_fps = 120
config.animation_fps = 120

-- Cursor (skip override in filming mode so Firecrawl's orange cursor shows)
if not filming then
  config.colors = {
    cursor_bg = '#7aa2f7',
    cursor_border = '#7aa2f7',
  }
end

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

-- Enable Kitty keyboard protocol (allows apps to distinguish Shift+Enter, etc.)
config.enable_kitty_keyboard = true

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

