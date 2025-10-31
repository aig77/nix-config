{
  config,
  pkgs,
  ...
}: {
  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;

    # MacOS specific settings
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

  environment = {
    systemPackages = with pkgs; [coreutils];
    systemPath = ["/usr/local/bin"];
    pathsToLink = ["/Applications"];
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    extraConfig = ''
      cask_args appdir: "~/Applications"
    '';
  };
}
