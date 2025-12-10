{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
  let
    configuration = { pkgs, ... }: {

      nixpkgs.config.allowUnfree = true;

      # Symlink sketchybar config from dotfiles
      home.file.".config/sketchybar/sketchybarrc" = {
        source = /Users/richardoliverbray/dotfiles/.config/sketchybar/sketchybarrc;
        executable = true;
      };

      # Symlink sketchybar colors
      home.file.".config/sketchybar/colors.sh" = {
        source = /Users/richardoliverbray/dotfiles/.config/sketchybar/colors.sh;
      };

      # Symlink sketchybar plugins
      home.file.".config/sketchybar/plugins" = {
        source = /Users/richardoliverbray/dotfiles/.config/sketchybar/plugins;
        recursive = true;
      };

      # Symlink launch agent
      home.file."Library/LaunchAgents/com.user.sketchybar.plist" = {
        source = /Users/richardoliverbray/dotfiles/Library/LaunchAgents/com.user.sketchybar.plist;
};

      # Symlink sketchybar main config
      home.file.".config/sketchybar/sketchybarrc" = {
        source = /Users/richardoliverbray/dotfiles/.config/sketchybar/sketchybarrc;
        executable = true;
      };
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
        ];

      homebrew = {
        enable = true;
        taps = [
          "nikitabobko/tap"
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
        home-manager.darwinModules.home-manager
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "richardoliverbray";
            autoMigrate = true;
          };
          
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.richardoliverbray = { pkgs, ... }: {
            home.stateVersion = "24.05";
            
            # Home Manager configuration
            programs.sketchybar = {
              enable = true;
              config = {
                # Your sketchybar configuration here
              };
            };
            
            # Launch agents
            launchd.agents = {
              sketchybar = {
                enable = true;
                config = {
                  ProgramArguments = [ "/Users/richardoliverbray/.config/sketchybar/sketchybarrc" ];
                  RunAtLoad = true;
                  KeepAlive = true;
                  StandardOutPath = "/tmp/sketchybar.out.log";
                  StandardErrorPath = "/tmp/sketchybar.err.log";
                };
              };
            };
          };
        }
      ];
    };
  };
}
