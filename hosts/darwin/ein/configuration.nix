{config, ...}: let
  modulesPath = ../../../modules;
in {
  imports = [
    (modulesPath + /darwin)
    (modulesPath + /common/home-manager.nix)
    (modulesPath + /common/sops.nix)
    ./theme.nix
    ./variables.nix
  ];

  homebrew = {
    # install desktop apps here
    casks = [
      "brave-browser"
      "claude"
      "discord"
      "docker-desktop"
      "ghostty"
      "httpie-desktop"
      "lm-studio"
      "raycast"
      "steam"
      "whatsapp"

      # experiencing issues
      # https://github.com/0xc000022070/zen-browser-flake/issues/128
      # https://nixpk.gs/pr-tracker.html?pr=449689
      "zen"
    ];

    masApps = {
      #  XCode = 497799835;
    };
  };

  system.primaryUser = config.var.username;
  home-manager.users.${config.var.username} = import ./home.nix;
}
