#!/usr/bin/env bash

set -uo pipefail

# ===== CONFIGURATION =====
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$DOTFILES_DIR/.backup"
IGNORE_FILES=(.zsh_history .zcompdump .bash_history .python_history .viminfo .DS_Store .CFUserTextEncoding)
IGNORE_DIRS=(node_modules .git __pycache__ target dist build .venv venv)

ROOT_FILES=(.zshrc .gitconfig .aerospace.toml .wezterm.lua)
CONFIG_DIRS=(fish nvim sketchybar mise nix helix kanata opencode)

# ===== OPTIONS =====
DRY_RUN=false
VERBOSE=false
FORCE=false
SKIP_CONFIRM=false

# ===== UTILITY FUNCTIONS =====

log() {
    echo -e "\e[1;34m[INFO]\e[0m $1"
}

warn() {
    echo -e "\e[1;33m[WARN]\e[0m $1" >&2
}

error() {
    echo -e "\e[1;31m[ERROR]\e[0m $1" >&2
}

verbose() {
    if $VERBOSE; then
        echo -e "\e[1;36m[DEBUG]\e[0m $1"
    fi
}

dry_run() {
    local cmd="$1"
    if $DRY_RUN; then
        echo -e "\e[1;32m[DRY-RUN]\e[0m $cmd"
    else
        verbose "Executing: $cmd"
        eval "$cmd"
    fi
}

# ===== HELPER FUNCTIONS =====

show_help() {
    cat << EOF
sync.sh - Sync home configuration files to dotfiles and create symlinks

USAGE:
    ./sync.sh [OPTIONS]

OPTIONS:
    -d, --dry-run     Show what would be done without making changes
    -v, --verbose     Show detailed output for each operation
    -y, --yes         Skip confirmation prompts
    -f, --force       Force overwrite even if dotfile is newer
    -b, --backup-dir  Custom backup directory (default: ~/dotfiles/.backup/)
    -h, --help        Show this help message

EXAMPLES:
    ./sync.sh --dry-run --verbose    # Preview changes
    ./sync.sh                        # Sync with confirmation
    ./sync.sh --yes --force          # Force sync all files
EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -y|--yes)
                SKIP_CONFIRM=true
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            -b|--backup-dir)
                BACKUP_DIR="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
}

should_ignore() {
    local filepath="$1"
    local filename
    filename=$(basename "$filepath")
    
    for ignore in "${IGNORE_FILES[@]}"; do
        if [[ "$filename" == "$ignore" ]]; then
            verbose "Ignoring: $filename"
            return 0
        fi
    done
    
    for ignore in "${IGNORE_DIRS[@]}"; do
        if [[ "$filepath" == *"/$ignore/"* ]]; then
            verbose "Ignoring directory: $ignore"
            return 0
        fi
    done
    
    return 1
}

is_symlinked() {
    local home_file="$1"
    local dotfile="$2"
    
    if [[ -L "$home_file" ]]; then
        local target
        target=$(readlink "$home_file" 2>/dev/null || true)
        if [[ "$target" == "$dotfile" ]]; then
            verbose "Already symlinked: $home_file -> $dotfile"
            return 0
        fi
    fi
    return 1
}

files_differ() {
    local file1="$1"
    local file2="$2"
    
    if ! diff -q "$file1" "$file2" >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

backup_file() {
    local file="$1"
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    local filename
    filename=$(basename "$file")
    local backup_path="$BACKUP_DIR/${filename}.${timestamp}"
    
    if [[ -e "$file" ]]; then
        dry_run "cp -a '$file' '$backup_path'"
        log "Backed up to: $backup_path"
    fi
}

copy_to_dotfiles() {
    local home_file="$1"
    local dotfile="$2"
    
    dry_run "mkdir -p '$(dirname "$dotfile")' && cp -a '$home_file' '$dotfile'"
    log "Copied to dotfiles: $dotfile"
}

create_symlink() {
    local home_file="$1"
    local dotfile="$2"
    
    if [[ -e "$home_file" && ! -L "$home_file" ]]; then
        dry_run "rm '$home_file'"
    fi
    
    dry_run "ln -s '$dotfile' '$home_file'"
    log "Created symlink: $home_file -> $dotfile"
}

confirm() {
    local prompt="$1"
    
    if $SKIP_CONFIRM; then
        return 0
    fi
    
    read -p "$prompt [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

sync_file() {
    local home_file="$1"
    local dotfile="$2"
    
    if [[ ! -e "$home_file" ]]; then
        verbose "File does not exist: $home_file"
        return 2
    fi
    
    if should_ignore "$home_file"; then
        return 2
    fi
    
    if is_symlinked "$home_file" "$dotfile"; then
        return 2
    fi
    
    local needs_copy=false
    local needs_backup=false
    
    if [[ ! -e "$dotfile" ]]; then
        verbose "Creating new dotfile: $dotfile"
        needs_copy=true
    elif files_differ "$home_file" "$dotfile"; then
        log "Changes detected: $home_file"
        needs_copy=true
        needs_backup=true
    else
        verbose "Files are identical, just creating symlink"
    fi
    
    if $needs_backup && ! $DRY_RUN && ! confirm "Sync $home_file?"; then
        return 2
    fi
    
    if $needs_backup; then
        backup_file "$home_file"
    fi
    
    if $needs_copy; then
        copy_to_dotfiles "$home_file" "$dotfile"
    fi
    
    create_symlink "$home_file" "$dotfile"
    return 0
}

sync_root_files() {
    log "Syncing root configuration files..."
    
    local synced=0
    local skipped=0
    
    for file in "${ROOT_FILES[@]}"; do
        verbose "Processing root file: $file"
        local home_file="$HOME/$file"
        local dotfile="$DOTFILES_DIR/$file"
        
        sync_file "$home_file" "$dotfile" || true
        verbose "Synced: $file"
        synced=$((synced + 1))
    done
    
    echo "Root files: $synced synced, $skipped skipped"
}

sync_config_files() {
    log "Syncing config directory files..."
    
    local synced=0
    local skipped=0
    
    for dir in "${CONFIG_DIRS[@]}"; do
        local config_dir="$HOME/.config/$dir"
        
        if [[ ! -d "$config_dir" ]]; then
            verbose "Config directory does not exist: $config_dir"
            continue
        fi
        
        verbose "Processing directory: $dir"
        local count=0
        for file in $(find "$config_dir" -type f 2>/dev/null); do
            verbose "Processing file: $file"
            count=$((count + 1))
            local rel_path="${file#$HOME/.config/}"
            local home_file="$HOME/.config/$rel_path"
            local dotfile="$DOTFILES_DIR/config/$rel_path"
            
            sync_file "$home_file" "$dotfile"
            local result=$?
            
            if [[ $result -eq 0 ]]; then
                synced=$((synced + 1))
            else
                skipped=$((skipped + 1))
            fi
        done
        verbose "Completed directory: $dir ($count files)"
    done
    
    echo "Config files: $synced synced, $skipped skipped"
}

sync_all() {
    local total_synced=0
    local total_skipped=0
    local start_time
    
    start_time=$(date +%s)
    
    if $DRY_RUN; then
        log "Running in dry-run mode, no changes will be made"
    fi
    
    sync_root_files
    
    sync_config_files
    
    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    echo ""
    log "Sync completed in ${duration}s"
    echo "Backup directory: $BACKUP_DIR"
    
    if $DRY_RUN; then
        log "This was a dry-run. Run without --dry-run to apply changes."
    fi
}

# ===== MAIN =====

main() {
    parse_args "$@"
    
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        error "Dotfiles directory not found: $DOTFILES_DIR"
        exit 1
    fi
    
    mkdir -p "$BACKUP_DIR"
    
    sync_all
}

main "$@"
