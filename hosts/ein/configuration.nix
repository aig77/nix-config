{config, ...}: {
  imports = [
    ../../modules/darwin
    ../../modules/nixos/home-manager.nix
    ./variables.nix
    ./theme.nix
  ];

  homebrew = {
    # not available in nixpkgs for darwin
    casks = [
      "raycast"
      "ghostty"
      "lm-studio"
    ];

    masApps = {
      #  XCode = 497799835;
    };
  };

  system.primaryUser = config.var.username;
  home-manager.users.arturo = import ./home.nix;
}
