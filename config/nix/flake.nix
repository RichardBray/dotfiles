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
        onActivation.cleanup = "zap";
        masApps = {
          "Keystroke Pro" = 15722062242;
        };
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
