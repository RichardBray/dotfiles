# Dotfiles

My personal configuration files and settings.

## Contents

- **SketchyBar**: macOS menu bar configuration
  - Location: `config/sketchybar/`
  - Symlinked to: `~/.config/sketchybar`

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
   ```

## Structure

```
dotfiles/
├── config/
│   └── sketchybar/
│       ├── sketchybarrc
│       ├── colors.sh
│       └── plugins/
└── README.md
```
