{config, ...}: {
  imports = [
    ../../modules/darwin
    ../../modules/nixos/home-manager.nix
    ./variables.nix
    ./theme.nix
  ];

  # Enable SSH daemon
  services.sshd.enable = true;

  homebrew = {
    # not available in nixpkgs for darwin
    casks = [
      "raycast"
      "ghostty"
      "lm-studio"
      "docker"
    ];

    masApps = {
      #  XCode = 497799835;
    };
  };

  system.primaryUser = config.var.username;
  home-manager.users.arturo = import ./home.nix;
}
