{
  config,
  inputs,
  pkgs,
  ...
}: {
  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    defaults = {
      controlcenter = {
        BatteryShowPercentage = true;
      };

      dock = {
        autohide = true;
        orientation = "bottom";
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXRemoveOldTrashItems = true;
      };

      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
      };
    };
  };

  #Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;

  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Disabled for Determinate systems nix
  nix.enable = false;

  # Use fish instead of default zsh
  programs.fish.enable = true;
  environment.shells = [pkgs.fish];

  users.users.${config.var.username} = {
    home = "/Users/${config.var.username}";
    shell = pkgs.fish;
  };

  # nixpkgs config is outside of darwin scope
  nixpkgs.config.allowUnfree = true;

  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [coreutils];
    systemPath = ["/usr/local/bin"];
    pathsToLink = ["/Applications"];
  };
}
