# Dotfiles

My personal configuration files and settings.

## Contents

- **SketchyBar**: macOS menu bar configuration
  - Location: `config/sketchybar/`
  - Symlinked to: `~/.config/sketchybar`

- **Aerospace**: Tiling window manager for macOS
  - Main config: `aerospace.toml`
  - Helpers: `config/aerospace/`
  - Symlinked to: `~/.aerospace.toml` and `~/.config/aerospace`

- **Fish Shell**: Command line shell configuration
  - Location: `config/fish/`
  - Symlinked to: `~/.config/fish`

## Installation

To set up these dotfiles on a new machine:

1. Clone this repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
   ```

2. Create symlinks:
   ```bash
   # SketchyBar
   ln -s ~/dotfiles/config/sketchybar ~/.config/sketchybar
   
   # Aerospace
   ln -s ~/dotfiles/aerospace.toml ~/.aerospace.toml
   ln -s ~/dotfiles/config/aerospace ~/.config/aerospace
   
   # Fish Shell
   ln -s ~/dotfiles/config/fish ~/.config/fish
   ```

## Structure

```
dotfiles/
├── aerospace.toml
├── config/
│   ├── aerospace/
│   │   ├── workspace_change.sh
│   │   └── workspace_move.sh
│   ├── fish/
│   │   ├── config.fish
│   │   ├── fish_plugins
│   │   ├── functions/
│   │   └── completions/
│   └── sketchybar/
│       ├── sketchybarrc
│       ├── colors.sh
│       └── plugins/
└── README.md
```
