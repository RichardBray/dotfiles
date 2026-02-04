# sync.sh Documentation

## Overview

`sync.sh` is a bash script designed to synchronize home configuration files from your system to your dotfiles repository and create symbolic links back to your home directory. This makes it easy to manage configuration files across different systems.

## Features

- **Bidirectional Sync**: Copies files from home directory to dotfiles and creates symlinks
- **Backup Support**: Automatically backs up existing files before overwriting
- **Selective Syncing**: Configurable lists of files and directories to sync
- **Ignore Patterns**: Built-in support for ignoring files and directories
- **Dry Run Mode**: Preview changes before applying them
- **Force Mode**: Force overwrite even if dotfile is newer
- **Detailed Logging**: Verbose output for debugging and monitoring

## Installation

Place `sync.sh` in your dotfiles directory and make it executable:

```bash
chmod +x sync.sh
```

## Usage

### Basic Usage

```bash
./sync.sh
```

This will:
1. Sync root configuration files (`.zshrc`, `.gitconfig`, etc.)
2. Sync config directories (`~/.config/fish`, `~/.config/nvim`, etc.)
3. Create backups of existing files in `~/.dotfiles/.backup/`
4. Create symlinks from home directory to dotfiles

### Options

```bash
./sync.sh [OPTIONS]
```

| Option | Short | Description |
|--------|-------|-------------|
| `--dry-run` | `-d` | Show what would be done without making changes |
| `--verbose` | `-v` | Show detailed output for each operation |
| `--yes` | `-y` | Skip confirmation prompts |
| `--force` | `-f` | Force overwrite even if dotfile is newer |
| `--backup-dir` | `-b` | Custom backup directory (default: `~/dotfiles/.backup/`) |
| `--help` | `-h` | Show help message |

### Examples

Preview changes before syncing:
```bash
./sync.sh --dry-run --verbose
```

Sync without confirmation:
```bash
./sync.sh --yes
```

Force sync all files:
```bash
./sync.sh --yes --force
```

Use custom backup directory:
```bash
./sync.sh --backup-dir ~/backups/dotfiles
```

## Configuration

### Files to Sync

The script syncs two types of files:

#### Root Files
Files directly in `~`:
- `.zshrc`
- `.gitconfig`
- `.aerospace.toml`
- `.wezterm.lua`

#### Config Directories
Directories in `~/.config`:
- `fish`
- `nvim`
- `sketchybar`
- `mise`
- `nix`
- `helix`
- `kanata`
- `opencode`

### Ignored Files

The following files are ignored during sync:

#### Individual Files
- `.zsh_history`
- `.zcompdump`
- `.bash_history`
- `.python_history`
- `.viminfo`
- `.DS_Store`
- `.CFUserTextEncoding`

#### Directories
- `node_modules`
- `.git`
- `__pycache__`
- `target`
- `dist`
- `build`
- `.venv`
- `venv`
- `.backup`

### Customizing Configuration

Edit the configuration section at the top of `sync.sh`:

```bash
# Add more root files
ROOT_FILES=(.zshrc .gitconfig .aerospace.toml .wezterm.lua .myconfig)

# Add more config directories
CONFIG_DIRS=(fish nvim sketchybar mise nix helix kanata opencode myapp)

# Add files to ignore
IGNORE_FILES=(.zsh_history .zcompdump .bash_history .my_secret_file)

# Add directories to ignore
IGNORE_DIRS=(node_modules .git __pycache__ .backup my_temp_dir)
```

## How It Works

1. **Initialization**: Parses command-line arguments and validates directories
2. **Root Files Sync**: Syncs files from `~` to `~/dotfiles/`
3. **Config Files Sync**: Syncs files from `~/.config/` to `~/dotfiles/config/`
4. **Symlink Creation**: Creates symlinks from home to dotfiles for all synced files

### Sync Process for Each File

1. Check if file exists in home directory
2. Check if file should be ignored
3. Check if file is already symlinked to dotfile
4. Compare file modification times if both exist
5. Backup existing file if needed
6. Copy file to dotfiles if needed
7. Create or update symlink

### Backup Process

Files are backed up before overwriting:
- Backup directory: `~/dotfiles/.backup/` (default)
- Backup format: `<filename>.<timestamp>`
- Example: `.zshrc.20260204_154612`

## Error Handling

The script includes error handling for:
- Missing directories
- Permission issues
- Invalid command-line arguments
- File access errors

## Troubleshooting

### Files not syncing
- Check if file is in the ignore lists
- Verify file paths are correct
- Run with `--verbose` to see detailed output

### Symlinks not created
- Ensure script has write permissions
- Check if file is already symlinked correctly
- Use `--dry-run` to preview what would happen

### Backup issues
- Verify backup directory is writable
- Check disk space
- Ensure backup directory exists

### Permission errors
- Run script with appropriate permissions
- Check file ownership
- Verify you can write to target directories

## Best Practices

1. **Always dry-run first**: Use `--dry-run` before making changes
2. **Review changes**: Check what files will be synced
3. **Backup important files**: Ensure backup directory has space
4. **Commit regularly**: Commit dotfiles after syncing
5. **Use verbose mode**: Use `--verbose` for troubleshooting
6. **Test on small changes**: Start with a few files, then expand

## Version Control

The `.backup/` directory is ignored by git to prevent committing temporary backup files. Add your backup directory to `.gitignore`:

```
.backup/
```

## Contributing

When modifying `sync.sh`:
1. Test with `--dry-run` first
2. Ensure backward compatibility
3. Update this documentation
4. Test on different configurations
5. Run with `--verbose` to verify behavior

## License

This script is part of your personal dotfiles repository. Use and modify as needed.