_: {
  flake.modules.darwin.base = {
    config,
    inputs,
    pkgs,
    ...
  }: {
    nix.enable = false;
    nixpkgs.hostPlatform = "aarch64-darwin";

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

    environment = {
      shells = [pkgs.${config.var.shell}];
      systemPackages = with pkgs; [coreutils nixos-rebuild];
      systemPath = ["/usr/local/bin"];
    };

    programs.${config.var.shell}.enable = true;

    users.users.${config.var.username} = {
      home = "/Users/${config.var.username}";
      shell = pkgs.${config.var.shell};
    };

    home-manager.users.${config.var.username}.imports = [
      inputs.mac-app-util.homeManagerModules.default
    ];

    nix-homebrew = {
      enable = true;
      user = config.var.username;
      autoMigrate = false; # set to true if you want to migrate from manually installed brew
    };

    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
        cleanup = "none";
      };
      extraConfig = ''
        cask_args appdir: "~/Applications"
      '';
    };

    sops = {
      defaultSopsFile = ./secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "${config.users.users.${config.var.username}.home}/.config/sops/age/keys.txt";
      secrets = {};
    };
  };
}
