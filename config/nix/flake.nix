{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
    let
    configuration = { pkgs, ... }: {

      nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.neovim
          pkgs.fzf
          pkgs.ripgrep
          pkgs.jq
          pkgs.lazygit
          pkgs.zoxide
          pkgs.superfile
          pkgs.opencode
          pkgs.ffmpeg_7
          pkgs.kanata
          pkgs.sketchybar
          pkgs.fish
          pkgs.eza
          pkgs.mise
          pkgs.claude-code
          pkgs.portaudio
        ];

      homebrew = {
        enable = true;
        taps = [
          "nikitabobko/tap"
        ];
        brews = [
          "displayplacer"
        ];
        casks = [
          "aerospace"
          "camtasia"
          "arc"
          "spotify"
          "elgato-camera-hub"
          "elgato-control-center"
          "vb-cable"
          "slack"
          "raycast"
          "wezterm"
          "shortcat"
          "macwhisper"
        ];
        masApps = {
          "Keystroke Pro" = 15722062242;
        };

        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      system.defaults = {
        dock.autohide = true;
        dock.tilesize = 45;
        dock.magnification = false;
      };

      system.primaryUser = "Richard Oliver Bray";

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;
      
      # Set fish as the default user shell
      users.users."richardoliverbray".shell = pkgs.fish;
      
      # Manage shell profile to prevent permission issues
      environment.shellInit = ''
        # Source Nix-managed environment
        if test -f /etc/static/bash/bashrc
          source /etc/static/bash/bashrc
        end
        
        # Set up environment variables
        set -gx PATH /run/current-system/sw/bin $PATH
        set -gx EDITOR nvim
        set -gx VISUAL nvim
      '';
      
      # Configure fish shell
      programs.fish.shellInit = ''
        # Fish-specific initialization
        set -gx fish_greeting ""
        set -gx fish_key_bindings fish_vi_key_bindings
        
        # Add Nix-managed packages to PATH
        fish_add_path /run/current-system/sw/bin
      '';
      
      # Symlink dotfiles
      system.activationScripts.symlinkDotfiles = ''
        # Create directories if they don't exist
        mkdir -p /Users/richardoliverbray/.config
        mkdir -p /Users/richardoliverbray/Library/LaunchAgents
        
        # Symlink sketchybar configuration
        ln -sf /Users/richardoliverbray/dotfiles/.config/sketchybar /Users/richardoliverbray/.config/sketchybar
        chmod +x /Users/richardoliverbray/.config/sketchybar/sketchybarrc
        
        # Symlink fish configuration
        ln -sf /Users/richardoliverbray/dotfiles/.config/fish /Users/richardoliverbray/.config/fish
        
        # Symlink launch agent
        ln -sf /Users/richardoliverbray/dotfiles/Library/LaunchAgents/com.user.sketchybar.plist /Users/richardoliverbray/Library/LaunchAgents/com.user.sketchybar.plist
      '';
      
      # Create a proper .profile to avoid permission issues
      system.activationScripts.profile.text = ''
        # Create a clean .profile file
        echo "# Managed by Nix" > /Users/richardoliverbray/.profile
        echo "export PATH=/run/current-system/sw/bin:\$PATH" >> /Users/richardoliverbray/.profile
        echo "export SHELL=/run/current-system/sw/bin/fish" >> /Users/richardoliverbray/.profile
        chown richardoliverbray:staff /Users/richardoliverbray/.profile
        chmod 644 /Users/richardoliverbray/.profile
        
        # Set default shell to Nix-managed fish
        if [ "$(dscl . -read /Users/richardoliverbray UserShell | awk '{print \$2}')" != "/run/current-system/sw/bin/fish" ]; then
          echo "Setting default shell to Nix fish..."
          dscl . -change /Users/richardoliverbray UserShell /opt/homebrew/bin/fish /run/current-system/sw/bin/fish 2>/dev/null || \
          dscl . -change /Users/richardoliverbray UserShell /bin/bash /run/current-system/sw/bin/fish 2>/dev/null || \
          dscl . -change /Users/richardoliverbray UserShell /bin/zsh /run/current-system/sw/bin/fish
        fi
      '';

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."my-mac" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "richardoliverbray";
            autoMigrate = true;
          };
        }
      ];
    };
  };
}
