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
          pkgs.atuin
          pkgs.helix
          pkgs.atuin
        ];

      homebrew = {
        enable = true;
        taps = [
          "nikitabobko/tap"
        ];
        brews = [
          "displayplacer"
          "starship"
        ];
        casks = [
          "aerospace"
          "affinity"
          "arc"
          "camtasia"
          "elgato-camera-hub"
          "elgato-control-center"
          "font-blex-mono-nerd-font"
          "karabiner-elements"
          "macwhisper"
          "raycast"
          "shortcat"
          "slack"
          "spotify"
          "vb-cable"
          "wezterm"
        ];
        masApps = {
          "Keystroke Pro" = 1572206224;
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
      };

      system.activationScripts.touchbar.text = ''
        defaults write com.apple.touchbar.agent PresentationModeGlobal "fullControlStrip"
        killall ControlCenter 2>/dev/null || true
      '';

      system.primaryUser = "robray";

      system.activationScripts.dotfiles.text = let
	homeDir = "/Users/robray";
	dotfilesDir = "${homeDir}/dotfiles/config";
	  symlinks = [
	    ["${dotfilesDir}/wezterm.lua" "${homeDir}/.config/wezterm/wezterm.lua"]
	    ["${dotfilesDir}/nvim" "${homeDir}/.config/nvim"]
	    ["${dotfilesDir}/fish" "${homeDir}/.config/fish"]
	  ];
	  mkSymlinkCmd = link: let
	    source = builtins.elemAt link 0;
	    target = builtins.elemAt link 1;
	  in ''
	    echo "Creating symlink: ${source} -> ${target}"
	    mkdir -p "$(dirname "${target}")"
	    ln -sfn "${source}" "${target}"
	  '';
	  
	in ''
	  echo "Setting up dotfiles symlinks..."
	  ${builtins.concatStringsSep "\n" (map mkSymlinkCmd symlinks)}
	  echo "Dotfiles setup complete!"
	'';

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
