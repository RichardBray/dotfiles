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
          # kanata is pinned here by flake.lock, but its Karabiner
          # VirtualHIDDevice driver is installed out-of-band by
          # ./karabiner-driver/install.sh. The two must move together:
          # kanata >= 1.13.0 needs driver v8.x, below that needs v6.x.
          # A mismatch shows up only as "connect_failed asio.system:61".
          # After `nix flake update`, check kanata's version against
          # KANATA_MAX_VERSION in that script.
          pkgs.kanata
          pkgs.lazygit
          pkgs.mise
          pkgs.neovim
          pkgs.ripgrep
          pkgs.zoxide
        ];

      homebrew = {
        enable = true;
        taps = [
          "nikitabobko/tap"
          "felixkratz/formulae"
        ];
        brews = [
          "cloudflared"
          "colima"
          "displayplacer"
          "docker"
          "docker-buildx"
          "docker-compose"
          "gh"
          "mas"
          "mole"
          "portaudio"
          "felixkratz/formulae/sketchybar"
          "starship"
          "superfile"
          "tailscale"
          "tree-sitter-cli"
        ];
        casks = [
          "nikitabobko/tap/aerospace"
          "affinity"
          "arc"
          "camtasia"
          "elgato-control-center"
          "font-blex-mono-nerd-font"
          "google-chrome"
          "logi-options+"
          # karabiner-elements deliberately omitted: kanata only needs the
          # DriverKit driver, installed pinned by ./karabiner-driver/install.sh.
          # Do NOT add it back and do NOT `brew uninstall --cask` it -- the
          # cask's uninstall stanza runs `delete: /Library/Application
          # Support/org.pqrs`, which would take the driver with it.
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
          "Tailscale" = 1475387142;
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
