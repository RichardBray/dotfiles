#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        warning "Running as root. This is fine for VPS setup."
    fi
}

# Update system packages
update_system() {
    log "Updating system packages..."
    if command -v apt-get &> /dev/null; then
        apt-get update && apt-get upgrade -y
        apt-get install -y curl wget git build-essential unzip
    elif command -v yum &> /dev/null; then
        yum update -y
        yum groupinstall -y "Development Tools"
        yum install -y curl wget git unzip
    elif command -v dnf &> /dev/null; then
        dnf update -y
        dnf groupinstall -y "Development Tools"
        dnf install -y curl wget git unzip
    elif command -v pacman &> /dev/null; then
        pacman -Syu --noconfirm
        pacman -S --noconfirm curl wget git base-devel unzip
    else
        error "Unsupported package manager. Please install curl, wget, git, build-essential/development tools, and unzip manually."
        exit 1
    fi
    success "System packages updated"
}

# Install zoxide
install_zoxide() {
    log "Installing zoxide..."
    if command -v zoxide &> /dev/null; then
        warning "Zoxide already installed, skipping..."
        return
    fi
    
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
    
    # Add zoxide init to bashrc
    if ! grep -q "zoxide init" ~/.bashrc; then
        echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
    fi
    
    # Also add to zshrc if it exists
    if [[ -f ~/.zshrc ]]; then
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.zshrc; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
        fi
        if ! grep -q "zoxide init" ~/.zshrc; then
            echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
        fi
    fi
    
    success "Zoxide installed"
}

# Install opencode
install_opencode() {
    log "Installing opencode..."
    if command -v opencode &> /dev/null; then
        warning "Opencode already installed, skipping..."
        return
    fi
    
    # Use the official install script
    log "Running opencode install script..."
    
    # Set install directory to ~/.local/bin if not root
    if [[ $EUID -ne 0 ]]; then
        mkdir -p ~/.local/bin
        export OPENCODE_INSTALL_DIR="$HOME/.local/bin"
        # Ensure ~/.local/bin is in PATH
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            if [[ -f ~/.zshrc ]]; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
            fi
        fi
    fi
    
    curl -fsSL https://opencode.ai/install | bash
    
    success "Opencode installed"
}

# Install Neovim
install_neovim() {
    log "Installing Neovim..."
    
    # Remove old version if installed via package manager
    if command -v apt-get &> /dev/null; then
        apt-get remove -y neovim || true
    elif command -v yum &> /dev/null; then
        yum remove -y neovim || true
    elif command -v dnf &> /dev/null; then
        dnf remove -y neovim || true
    elif command -v pacman &> /dev/null; then
        pacman -R --noconfirm neovim || true
    fi
    
    # Install latest Neovim from GitHub releases
    cd /tmp
    NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
    log "Installing Neovim $NVIM_VERSION"
    
    curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
    tar -xzf nvim-linux-x86_64.tar.gz
    
    if [[ $EUID -eq 0 ]]; then
        mv nvim-linux-x86_64 /opt/nvim
        ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    else
        mkdir -p ~/.local
        mv nvim-linux-x86_64 ~/.local/nvim
        mkdir -p ~/.local/bin
        ln -sf ~/.local/nvim/bin/nvim ~/.local/bin/nvim
        # Ensure ~/.local/bin is in PATH
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            if [[ -f ~/.zshrc ]]; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
            fi
        fi
    fi
    
    rm -f nvim-linux-x86_64.tar.gz
    
    success "Neovim installed"
}

# Install Node.js (required for some nvim plugins)
install_nodejs() {
    log "Installing Node.js..."
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        log "Node.js already installed: $NODE_VERSION"
        return
    fi
    
    # Install Node.js using NodeSource repository
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - 2>/dev/null || {
        # Fallback for non-Ubuntu/Debian systems
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install --lts
        nvm use --lts
    }
    
    if command -v apt-get &> /dev/null; then
        apt-get install -y nodejs
    fi
    
    success "Node.js installed"
}

# Setup NvChad configuration
setup_nvchad() {
    log "Setting up NvChad configuration..."
    
    # Backup existing neovim config if it exists
    if [[ -d ~/.config/nvim ]]; then
        warning "Backing up existing Neovim configuration..."
        mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # Create config directory
    mkdir -p ~/.config
    
    # Clone your dotfiles nvim config
    log "Cloning NvChad configuration from your dotfiles..."
    git clone https://github.com/RichardBray/dotfiles.git /tmp/dotfiles
    cp -r /tmp/dotfiles/config/nvim ~/.config/
    rm -rf /tmp/dotfiles
    
    # Remove supermaven configuration
    log "Removing supermaven configuration..."
    if [[ -f ~/.config/nvim/lua/plugins/supermaven.lua ]]; then
        rm ~/.config/nvim/lua/plugins/supermaven.lua
        success "Removed supermaven plugin file"
    fi
    
    # Remove supermaven references from cmp.lua
    if [[ -f ~/.config/nvim/lua/plugins/cmp.lua ]]; then
        log "Removing supermaven references from cmp.lua..."
        # Create a temporary file to store the modified content
        sed '/supermaven/d' ~/.config/nvim/lua/plugins/cmp.lua > /tmp/cmp_temp.lua
        mv /tmp/cmp_temp.lua ~/.config/nvim/lua/plugins/cmp.lua
        success "Removed supermaven references from cmp.lua"
    fi
    
    # Remove supermaven from lazy-lock.json if it exists
    if [[ -f ~/.config/nvim/lazy-lock.json ]]; then
        log "Removing supermaven from lazy-lock.json..."
        sed '/"supermaven-nvim"/d' ~/.config/nvim/lazy-lock.json > /tmp/lock_temp.json
        mv /tmp/lock_temp.json ~/.config/nvim/lazy-lock.json
        success "Removed supermaven from lazy-lock.json"
    fi
    
    # Install lazy.nvim
    log "Installing lazy.nvim plugin manager..."
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
    
    success "NvChad configuration installed (without supermaven)"
}

# Install additional tools and dependencies
install_additional_tools() {
    log "Installing additional development tools..."
    
    # Install ripgrep for telescope
    if ! command -v rg &> /dev/null; then
        if command -v apt-get &> /dev/null; then
            apt-get install -y ripgrep
        elif command -v yum &> /dev/null; then
            yum install -y ripgrep
        elif command -v dnf &> /dev/null; then
            dnf install -y ripgrep
        else
            # Install from GitHub releases as fallback
            cd /tmp
            RG_VERSION=$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
            curl -LO "https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz"
            tar -xzf ripgrep-*.tar.gz
            if [[ $EUID -eq 0 ]]; then
                mv ripgrep-*/rg /usr/local/bin/
            else
                mkdir -p ~/.local/bin
                mv ripgrep-*/rg ~/.local/bin/
            fi
            rm -rf ripgrep-*
        fi
    fi
    
    # Install fd for better file finding
    if ! command -v fd &> /dev/null; then
        if command -v apt-get &> /dev/null; then
            apt-get install -y fd-find
            # Create symlink if fd is installed as fdfind
            if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then
                if [[ $EUID -eq 0 ]]; then
                    ln -sf $(which fdfind) /usr/local/bin/fd
                else
                    mkdir -p ~/.local/bin
                    ln -sf $(which fdfind) ~/.local/bin/fd
                fi
            fi
        elif command -v yum &> /dev/null; then
            yum install -y fd-find
        elif command -v dnf &> /dev/null; then
            dnf install -y fd-find
        fi
    fi
    
    success "Additional tools installed"
}

# Setup shell environment
setup_shell_env() {
    log "Setting up shell environment..."
    
    # Source the updated bashrc in current session
    if [[ -f ~/.bashrc ]]; then
        # Add a marker to avoid duplicate sourcing
        if ! grep -q "# VPS Setup Complete" ~/.bashrc; then
            echo "" >> ~/.bashrc
            echo "# VPS Setup Complete - $(date)" >> ~/.bashrc
        fi
    fi
    
    success "Shell environment configured"
}

# Main function
main() {
    log "Starting VPS setup script..."
    log "This script will install: zoxide, opencode, neovim, and NvChad configuration (without supermaven)"
    
    check_root
    update_system
    install_nodejs
    install_zoxide
    install_opencode
    install_neovim
    install_additional_tools
    setup_nvchad
    setup_shell_env
    
    echo ""
    success "✅ VPS setup complete!"
    echo ""
    echo -e "${GREEN}Next steps:${NC}"
    echo -e "  1. ${YELLOW}Source your shell configuration:${NC} source ~/.bashrc (or restart your shell)"
    echo -e "  2. ${YELLOW}Start Neovim:${NC} nvim (plugins will install automatically on first run)"
    echo -e "  3. ${YELLOW}Test zoxide:${NC} z <directory_name> after visiting some directories"
    echo -e "  4. ${YELLOW}Start opencode:${NC} opencode (configure with your preferred AI provider)"
    echo ""
    echo -e "${BLUE}Installed versions:${NC}"
    [[ -x ~/.local/bin/zoxide || -x /usr/local/bin/zoxide ]] && echo -e "  • Zoxide: $(zoxide --version 2>/dev/null || echo 'installed')"
    [[ -x ~/.local/bin/opencode || -x /usr/local/bin/opencode ]] && echo -e "  • Opencode: $(opencode --version 2>/dev/null || echo 'installed')"
    [[ -x ~/.local/bin/nvim || -x /usr/local/bin/nvim ]] && echo -e "  • Neovim: $(nvim --version 2>/dev/null | head -n1 || echo 'installed')"
    echo ""
    warning "Please restart your shell or run 'source ~/.bashrc' to use the new tools!"
    echo ""
    echo -e "${BLUE}Additional info:${NC}"
    echo -e "  • Your NvChad config includes TypeScript, Go LSP support, and custom keybindings"
    echo -e "  • Supermaven has been removed from the configuration"
    echo -e "  • See https://opencode.ai/docs for opencode configuration options"
    echo -e "  • All tools are installed in ~/.local/bin (or system-wide if running as root)"
}

# Run main function
main "$@"
