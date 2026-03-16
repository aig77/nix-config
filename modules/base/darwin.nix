{
  flake.darwinModules.base = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.var) username shell;
  in {
    system = {
      stateVersion = 5;

      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToControl = true;
      };

      defaults = {
        controlcenter.BatteryShowPercentage = true;

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

        NSGlobalDomain.AppleInterfaceStyle = "Dark";
      };
    };

    nixpkgs.hostPlatform = "aarch64-darwin";

    nix.enable = false;

    environment.shells = with pkgs; [fish zsh];
    programs.${shell}.enable = true;

    users.users.${username} = {
      home = "/Users/${username}";
      shell = pkgs.${shell};
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
  };
}
