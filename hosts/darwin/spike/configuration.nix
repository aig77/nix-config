{config, ...}: let
  modulesPath = ../../../modules;
  themesPath = ../../../themes;
in {
  imports = [
    (modulesPath + /darwin)
    (modulesPath + /common/home-manager.nix)
    (modulesPath + /common/sops.nix)
    (themesPath + /catppuccin_darwin.nix)
    ./variables.nix
  ];

  homebrew = {
    # not available in nixpkgs for darwin
    casks = [
      "docker"
      "discord"
      "ghostty"
      "lm-studio"
      "raycast"
      "zen-browser"
    ];

    masApps = {
      #  XCode = 497799835;
    };
  };

  system.primaryUser = config.var.username;
  home-manager.users.${config.var.username} = import ./home.nix;
}
