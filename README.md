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

- **Neovim**: Text editor configuration (NvChad-based)
  - Location: `config/nvim/`
  - Symlinked to: `~/.config/nvim`

- **Tmux**: Terminal multiplexer configuration
  - Location: `tmux.conf`
  - Symlinked to: `~/.tmux.conf`

- **Claude**: Claude AI configuration and settings
  - Location: `.claude/`
  - Symlinked to: `~/.claude`
  - Contains settings, hooks, audio files, and project configurations

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
   
   # Neovim
   ln -s ~/dotfiles/config/nvim ~/.config/nvim
   
   # Tmux
   ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
   
   # Claude
   ln -s ~/dotfiles/.claude ~/.claude
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
│   ├── nvim/
│   │   ├── init.lua
│   │   ├── lua/
│   │   └── spell/
│   └── sketchybar/
│       ├── sketchybarrc
│       ├── colors.sh
│       └── plugins/
├── tmux.conf
└── README.md
```
