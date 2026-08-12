# Dotfiles

My personal macOS configuration files and settings.

Configs live in this repo and are **symlinked** into place, so editing a file
here (or in `~/.config`) is the same file — changes track automatically in git.

## Contents

| Tool | Location | Symlinked to |
|------|----------|--------------|
| **Aerospace** – tiling WM | `.aerospace.toml`, `config/aerospace/` | `~/.aerospace.toml`, `~/.config/aerospace` |
| **WezTerm** – terminal | `.wezterm.lua` | `~/.wezterm.lua` |
| **Fish** – shell | `config/fish/` | `~/.config/fish` |
| **Neovim** – editor (NvChad-based) | `config/nvim/` | `~/.config/nvim` |
| **Helix** – editor | `config/helix/` | `~/.config/helix` |
| **Kanata** – keyboard remapper | `config/kanata/` | `~/.config/kanata` |
| **mise** – runtime/tool manager | `config/mise/` | `~/.config/mise` |
| **Nix** – system config | `config/nix/` | `~/.config/nix` |
| **SketchyBar** – menu bar | `config/sketchybar/` | `~/.config/sketchybar` |
| **opencode** – AI coding agent | `config/opencode/` | `~/.config/opencode` |
| **Claude** – Claude Code config | `.claude/` | `~/.claude` |
| **Git** | `.gitconfig` | `~/.gitconfig` |
| **Zsh** | `.zshrc` | `~/.zshrc` |

## Syncing

`sync.sh` adopts config files from your home directory into this repo and
replaces them with symlinks. Use it when you set up a **new** tool and want to
start tracking its config:

```bash
./sync.sh --dry-run   # preview what it would touch
./sync.sh             # adopt + symlink
```

Note: `sync.sh` is one-way (home → repo). It does not deploy the repo onto a
fresh machine — for that, clone the repo and symlink manually (see below).
Already-symlinked files are skipped, so it's safe to re-run.

## New machine setup

For a fresh Mac, follow [docs/new-mac-setup.md](docs/new-mac-setup.md) — it covers
installing Nix, applying the nix-darwin flake (packages, casks, App Store apps),
and the errors that come up along the way.

To only link configs on a machine that is already set up:

```bash
git clone https://github.com/richardbray/dotfiles.git ~/dotfiles

# Root files
ln -s ~/dotfiles/.aerospace.toml ~/.aerospace.toml
ln -s ~/dotfiles/.wezterm.lua    ~/.wezterm.lua
ln -s ~/dotfiles/.gitconfig      ~/.gitconfig
ln -s ~/dotfiles/.zshrc          ~/.zshrc
ln -s ~/dotfiles/.claude         ~/.claude

# Config dirs
for d in aerospace fish nvim helix kanata mise nix sketchybar opencode; do
  ln -s ~/dotfiles/config/$d ~/.config/$d
done
```

### Calendar scripts (`agenda`, `cal-notify`)

`agenda` prints upcoming macOS calendar events; `cal-notify` fires a
notification 5 min and 1 min before each event, driven by a launchd agent.
Both read the local calendar store via icalBuddy - no network, no API keys.

```bash
brew install ical-buddy

mkdir -p ~/.local/bin ~/.local/share/cal ~/.local/state/cal
ln -s ~/dotfiles/bin/agenda          ~/.local/bin/agenda
ln -s ~/dotfiles/bin/cal-notify      ~/.local/bin/cal-notify
ln -s ~/dotfiles/share/cal/events.sh ~/.local/share/cal/events.sh

# Background notifications (optional)
ln -s ~/dotfiles/Library/LaunchAgents/com.robray.cal-notify.plist \
      ~/Library/LaunchAgents/com.robray.cal-notify.plist
launchctl load ~/Library/LaunchAgents/com.robray.cal-notify.plist
```

Make sure `~/.local/bin` is on `PATH`. The first run prompts for calendar
access; if notifications never appear, grant Script Editor access under
System Settings > Notifications.

Other setup scripts: `mise-setup.sh` (tool installs), `vps_setup.sh` (server
provisioning).
