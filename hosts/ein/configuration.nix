{config, ...}: {
  imports = [
    ../../modules/darwin
    ../../modules/nixos/home-manager.nix
    ./variables.nix
    ./theme.nix
  ];

  homebrew = {
    casks = [
      "raycast"
      "ghostty" # temporary while home manager doesnt work
      "lm-studio"
    ];

    masApps = {
      #  XCode = 497799835;
    };
  };

  system.primaryUser = config.var.username;
  home-manager.users.arturo = import ./home.nix;
}
