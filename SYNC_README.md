# Dotfiles Sync Script

## Description
`sync.sh` automatically syncs your home configuration files to your dotfiles repository and replaces them with symlinks.

## Usage

```bash
./sync.sh [OPTIONS]
```

### Options
- `-d, --dry-run`: Show what would be done without making changes
- `-v, --verbose`: Show detailed output for each operation
- `-y, --yes`: Skip confirmation prompts
- `-f, --force`: Force overwrite even if dotfile is newer
- `-b, --backup-dir`: Custom backup directory (default: ~/dotfiles/.backup/)
- `-h, --help`: Show help message

### Examples

```bash
# Preview changes
./sync.sh --dry-run --verbose

# Sync with confirmation prompts
./sync.sh

# Force sync all files without confirmation
./sync.sh --yes --force

# Sync with custom backup location
./sync.sh --backup-dir ~/backups/dotfiles
```

## What Gets Synced

### Root-level files
- `.zshrc`
- `.gitconfig`
- `.aerospace.toml`
- `.wezterm.lua`

### Config directories
- `~/.config/fish/`
- `~/.config/nvim/`
- `~/.config/sketchybar/`
- `~/.config/mise/`
- `~/.config/nix/`
- `~/.config/helix/`
- `~/.config/kanata/`
- `~/.config/opencode/`

## What Gets Ignored

### Files
- `.zsh_history`
- `.zcompdump`
- `.bash_history`
- `.python_history`
- `.viminfo`
- `.DS_Store`
- `.CFUserTextEncoding`

### Directories
- `node_modules/`
- `.git/`
- `__pycache__/`
- `target/`
- `dist/`
- `build/`
- `.venv/`
- `venv/`

## How It Works

1. **Detects changes**: Compares home config files against dotfiles repository using `diff`
2. **Backs up originals**: Creates timestamped backups in `~/dotfiles/.backup/`
3. **Copies changes**: Copies modified files from home to dotfiles repository
4. **Creates symlinks**: Replaces home files with symlinks to dotfiles versions

## Safety Features

- **Dry-run mode**: Preview changes before applying
- **Backup directory**: All original files are backed up before symlinking
- **Confirmation prompts**: Requires confirmation before making destructive changes (use `-y` to skip)
- **Ignore patterns**: Automatically skips transient files and build artifacts
- **Idempotent**: Safe to run multiple times

## Recovery

If something goes wrong, you can restore files from the backup directory:

```bash
ls ~/dotfiles/.backup/
cp ~/dotfiles/.backup/<file>.<timestamp> ~/<file>
```
