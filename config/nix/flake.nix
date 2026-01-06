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
          pkgs.atuin
          pkgs.eza
          pkgs.ffmpeg_7
          pkgs.fish
          pkgs.fzf
          pkgs.helix
          pkgs.jq
          pkgs.kanata
          pkgs.lazygit
          pkgs.mise
          pkgs.neovim
          pkgs.opencode
          pkgs.ripgrep
          pkgs.zoxide
        ];

      homebrew = {
        enable = true;
        taps = [
          "nikitabobko/tap"
          "FelixKratz/formulae"
        ];
        brews = [
          "displayplacer"
          "mole"
          "portaudio"
          "sketchybar"
          "starship"
          "superfile"
          "typos-ls"
        ];
        casks = [
          "aerospace"
          "affinity"
          "arc"
          "camtasia"
          "elgato-control-center"
          "font-blex-mono-nerd-font"
          "logi-options+"
          "karabiner-elements"
          "raycast"
          "shortcat"
          "slack"
          "spotify"
          "vb-cable"
          "wezterm"
        ];
        masApps = {
          "Keystroke Pro" = 1572206224;
          "Davinci Resolve" = 571213070;
        };

        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      system.defaults = {
        dock.autohide = true;
        dock.tilesize = 45;
        dock.magnification = false;
        dock.persistent-apps = [];
        NSGlobalDomain._HIHideMenuBar = false;
      };

      system.primaryUser = "robray";

      system.activationScripts.dotfiles.text = let
    	homeDir = "/Users/robray";
    	dotfilesDir = "${homeDir}/dotfiles/config";
      in "";

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;

      # Add fish to /etc/shells
      environment.shells = [ pkgs.fish ];
      
      # Set fish as the default user shell
      users.users.robray.shell = pkgs.fish;
      
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
            user = "robray";
            autoMigrate = true;
          };
        }
      ];
    };
  };
}
