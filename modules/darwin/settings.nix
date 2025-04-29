{ config, inputs, pkgs, ... }: {
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
  
  #Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;
    
  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Disabled for Determinate systems nix
  nix.enable = false;

  users.users.arturo.home = "/Users/${config.var.username}";
  
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
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
    systemPackages = with pkgs; [ coreutils ];
    systemPath = [ "/usr/local/bin" ];
    pathsToLink = [ "/Applications" ];
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
    };

    finder = {
      AppleShowAllExtensions = true;
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
    };
  };
}
